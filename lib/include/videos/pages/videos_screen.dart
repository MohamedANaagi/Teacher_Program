import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

// BLoC Events
abstract class VideoEvent {}

class FetchVideos extends VideoEvent {
  final String courseName;
  FetchVideos(this.courseName);
}

class SelectVideo extends VideoEvent {
  final String videoUrl;
  SelectVideo(this.videoUrl);
}

// BLoC States
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<String> videoUrls;
  final Map<String, CachedVideoPlayerController> videoControllers;
  final Map<String, double> videoProgress;
  final String? selectedVideoUrl;
  VideoLoaded({
    required this.videoUrls,
    required this.videoControllers,
    required this.videoProgress,
    this.selectedVideoUrl,
  });
}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}

// BLoC
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoInitial()) {
    on<FetchVideos>(_onFetchVideos);
    on<SelectVideo>(_onSelectVideo);
  }

  Future<void> _onFetchVideos(
      FetchVideos event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    try {
      // Fetch video URLs from Firebase
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('courses/${event.courseName}');
      final result = await ref.listAll();
      final videoUrls = await Future.wait(
        result.items.map((item) => item.getDownloadURL()),
      );

      // Initialize all video controllers
      final videoControllers = <String, CachedVideoPlayerController>{};
      for (var url in videoUrls) {
        final controller = CachedVideoPlayerController.network(url);
        await controller.initialize();
        videoControllers[url] = controller;
      }

      // Load video progress
      final prefs = await SharedPreferences.getInstance();
      final videoProgress = <String, double>{};
      for (var video in (prefs
          .getKeys()
          .where((key) => key.startsWith('progress_${event.courseName}_')))) {
        final videoUrl =
            video.replaceFirst('progress_${event.courseName}_', '');
        videoProgress[videoUrl] = prefs.getDouble(video) ?? 0.0;
      }

      emit(VideoLoaded(
        videoUrls: videoUrls,
        videoControllers: videoControllers,
        videoProgress: videoProgress,
        selectedVideoUrl: null,
      ));
    } catch (e) {
      emit(VideoError('Failed to load videos: $e'));
    }
  }

  Future<void> _onSelectVideo(
      SelectVideo event, Emitter<VideoState> emit) async {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      emit(VideoLoading());
      final controller = currentState.videoControllers[event.videoUrl];
      if (controller != null &&
          currentState.videoProgress.containsKey(event.videoUrl)) {
        controller.seekTo(Duration(
            seconds: (currentState.videoProgress[event.videoUrl]! *
                    controller.value.duration.inSeconds)
                .toInt()));
      }
      emit(VideoLoaded(
        videoUrls: currentState.videoUrls,
        videoControllers: currentState.videoControllers,
        videoProgress: currentState.videoProgress,
        selectedVideoUrl: event.videoUrl,
      ));
    }
  }

  @override
  Future<void> close() {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      for (var controller in currentState.videoControllers.values) {
        controller.dispose();
      }
    }
    return super.close();
  }
}

class VideosScreen extends StatelessWidget {
  final String courseName;

  const VideosScreen({required this.courseName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc()..add(FetchVideos(courseName)),
      child: VideosScreenContent(courseName: courseName),
    );
  }
}

class VideosScreenContent extends StatefulWidget {
  final String courseName;

  const VideosScreenContent({required this.courseName, Key? key})
      : super(key: key);

  @override
  _VideosScreenContentState createState() => _VideosScreenContentState();
}

class _VideosScreenContentState extends State<VideosScreenContent> {
  CustomVideoPlayerController? _customVideoPlayerController;

  @override
  void dispose() {
    _customVideoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _saveVideoProgress(String videoUrl, double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress_${widget.courseName}_$videoUrl', position);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is VideoError) {
              return Center(child: Text(state.message));
            }
            if (state is VideoLoaded) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 2 / 3,
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.black,
                      child: state.selectedVideoUrl != null
                          ? _buildVideoPlayer(
                              context, state, state.selectedVideoUrl!)
                          : Center(
                              child: Text(
                                'اختر فيديو لتشغيله',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  // Video List
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[100],
                      child: ListView.builder(
                        itemCount: state.videoUrls.length,
                        itemBuilder: (context, index) {
                          final videoUrl = state.videoUrls[index];
                          final progress = state.videoProgress[videoUrl] ?? 0.0;
                          return VideoItem(
                            videoUrl: videoUrl,
                            isSelected: videoUrl == state.selectedVideoUrl,
                            onTap: () {
                              context
                                  .read<VideoBloc>()
                                  .add(SelectVideo(videoUrl));
                            },
                            progress: progress,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(
      BuildContext context, VideoLoaded state, String videoUrl) {
    final controller = state.videoControllers[videoUrl]!;
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: controller,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
        showSeekButtons: true,
        showFullscreenButton: true,
        showMuteButton: true,
        allowVolumeOnSlide: true,
        customAspectRatio: 16 / 9,
        seekDuration: Duration(seconds: 10),
        showDurationPlayed: true,
        showDurationRemaining: true,
        controlBarPadding: EdgeInsets.all(8.0),
        controlsPadding: EdgeInsets.all(8.0),
        controlBarDecoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        durationPlayedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        durationRemainingTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        autoFadeOutControls: true,
        durationAfterControlsFadeOut: Duration(seconds: 3),
        showPlayButton: true,
        settingsButtonAvailable: true,
        playbackSpeedButtonAvailable: true,
        playOnlyOnce: false,
        enterFullscreenOnStart: false,
        exitFullscreenOnEnd: false,
      ),
    );

    // Listen to position changes for progress tracking
    controller.addListener(() {
      final position = controller.value.position.inSeconds.toDouble();
      final duration = controller.value.duration.inSeconds.toDouble();
      if (duration > 0) {
        _saveVideoProgress(videoUrl, position / duration);
      }
    });

    controller.play();

    return Stack(
      children: [
        CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController!,
        ),
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

class VideoItem extends StatelessWidget {
  final String videoUrl;
  final bool isSelected;
  final VoidCallback onTap;
  final double progress;

  const VideoItem({
    required this.videoUrl,
    required this.isSelected,
    required this.onTap,
    required this.progress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: isSelected ? 8 : 2,
      child: ListTile(
        leading: Icon(
          Icons.video_library,
          color: isSelected ? Colors.blueAccent : Colors.grey,
        ),
        title: Text(
          videoUrl.split('/').last,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
        tileColor: isSelected ? Colors.blue.shade50 : null,
        onTap: onTap,
      ),
    );
  }
}
