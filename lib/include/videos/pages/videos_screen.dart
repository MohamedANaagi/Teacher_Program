import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

// BLoC Events
abstract class VideoEvent {}

class FetchVideos extends VideoEvent {
  final String courseName;
  FetchVideos(this.courseName);
}

class SelectVideo extends VideoEvent {
  final String videoUrl;
  final String videoName;
  final String courseName; // Added to pass courseName
  SelectVideo(this.videoUrl, this.videoName, this.courseName);
}

// BLoC States
abstract class VideoState {}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<Map<String, String>> videos; // Stores {url, name}
  final Map<String, CachedVideoPlayerController> videoControllers;
  final Map<String, double> videoProgress;
  final String? selectedVideoUrl;
  final String? testLink;
  final String courseName; // Added to store courseName
  VideoLoaded({
    required this.videos,
    required this.videoControllers,
    required this.videoProgress,
    required this.courseName,
    this.selectedVideoUrl,
    this.testLink,
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
      // Fetch video URLs and names from Firebase
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child('courses/${event.courseName}');
      final result = await ref.listAll();
      final videos = <Map<String, String>>[];
      for (var item in result.items) {
        final url = await item.getDownloadURL();
        videos.add({'url': url, 'name': item.name});
      }

      // Initialize all video controllers
      final videoControllers = <String, CachedVideoPlayerController>{};
      for (var video in videos) {
        final controller = CachedVideoPlayerController.network(video['url']!);
        await controller.initialize();
        videoControllers[video['url']!] = controller;
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
        videos: videos,
        videoControllers: videoControllers,
        videoProgress: videoProgress,
        courseName: event.courseName,
        selectedVideoUrl: null,
        testLink: null,
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
      String? testLink;

      // Fetch test link from Firestore
      print('Querying test link for course: ${event.courseName}, video: ${event.videoName}');
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('tests_links')
            .where('courseName', isEqualTo: event.courseName)
            .where('videoName', isEqualTo: event.videoName)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          testLink = querySnapshot.docs.first.data()['testLink'] as String?;
          print('Test link found: $testLink');
        } else {
          print('No test link found for ${event.videoName}');
        }
      } catch (e) {
        print('Error fetching test link: $e');
      }

      if (controller != null &&
          currentState.videoProgress.containsKey(event.videoUrl)) {
        controller.seekTo(Duration(
            seconds: (currentState.videoProgress[event.videoUrl]! *
                controller.value.duration.inSeconds)
                .toInt()));
      }
      emit(VideoLoaded(
        videos: currentState.videos,
        videoControllers: currentState.videoControllers,
        videoProgress: currentState.videoProgress,
        courseName: currentState.courseName,
        selectedVideoUrl: event.videoUrl,
        testLink: testLink,
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
              return const Center(child: CircularProgressIndicator());
            }
            if (state is VideoError) {
              return Center(child: Text(state.message));
            }
            if (state is VideoLoaded) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player Section
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Black Video Player Container
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.5,
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: state.selectedVideoUrl != null
                                  ? _buildVideoPlayer(
                                  context, state, state.selectedVideoUrl!)
                                  : const Center(
                                child: Text(
                                  'اختر فيديو لتشغيله',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Test Link Button (Outside Black Container)
                        if (state.selectedVideoUrl != null &&
                            state.testLink != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () async {
                                  final url = Uri.parse(state.testLink!);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                      webViewConfiguration:
                                      const WebViewConfiguration(
                                          enableJavaScript: true),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('لا يمكن فتح الرابط'),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9800),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 16),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.quiz,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'الذهاب إلى الاختبار',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  // Video List Section
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: state.videos.length,
                        itemBuilder: (context, index) {
                          final video = state.videos[index];
                          final videoUrl = video['url']!;
                          final videoName = video['name']!;
                          final progress = state.videoProgress[videoUrl] ?? 0.0;
                          return VideoItem(
                            videoUrl: videoUrl,
                            videoName: videoName,
                            isSelected: videoUrl == state.selectedVideoUrl,
                            onTap: () {
                              context.read<VideoBloc>().add(
                                SelectVideo(
                                    videoUrl, videoName, state.courseName),
                              );
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
            return const Center(child: CircularProgressIndicator());
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
        controlBarPadding: EdgeInsets.all(12.0),
        controlsPadding: EdgeInsets.all(12.0),
        controlBarDecoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        durationPlayedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        durationRemainingTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
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
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
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
  final String videoName;
  final bool isSelected;
  final VoidCallback onTap;
  final double progress;

  const VideoItem({
    required this.videoUrl,
    required this.videoName,
    required this.isSelected,
    required this.onTap,
    required this.progress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: isSelected ? 10 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFF9800).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Icon(
              Icons.video_library,
              color: isSelected ? const Color(0xFFFF9800) : Colors.grey[600],
              size: 30,
            ),
            title: Text(
              videoName,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 18,
                color: isSelected ? const Color(0xFFFF9800) : Colors.black87,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}