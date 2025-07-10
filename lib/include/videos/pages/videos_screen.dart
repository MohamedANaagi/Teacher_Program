import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideosScreen extends StatefulWidget {
  final String courseName;

  const VideosScreen({required this.courseName, Key? key}) : super(key: key);

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late Future<List<String>> _videosFuture;
  CachedVideoPlayerController? _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  String? _selectedVideo;
  Map<String, double> _videoProgress = {};

  @override
  void initState() {
    super.initState();
    _videosFuture = _fetchVideos();
    _loadVideoProgress();
  }

  Future<void> _loadVideoProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _videoProgress = {};
      for (var video in (prefs
          .getKeys()
          .where((key) => key.startsWith('progress_${widget.courseName}_')))) {
        final videoUrl =
            video.replaceFirst('progress_${widget.courseName}_', '');
        _videoProgress[videoUrl] = prefs.getDouble(video) ?? 0.0;
      }
    });
  }

  Future<void> _saveVideoProgress(String videoUrl, double position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress_${widget.courseName}_$videoUrl', position);
    setState(() {
      _videoProgress[videoUrl] = position;
    });
  }

  Future<List<String>> _fetchVideos() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('courses/${widget.courseName}');
    final result = await ref.listAll();
    return await Future.wait(
      result.items.map((item) => item.getDownloadURL()),
    );
  }

  void _playVideo(String videoUrl) async {
    if (_videoPlayerController != null) {
      await _videoPlayerController!.dispose();
    }
    _videoPlayerController = CachedVideoPlayerController.network(videoUrl);
    await _videoPlayerController!.initialize();

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController!,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
        showSeekButtons: true,
        showFullscreenButton: true,
        showMuteButton: true,
        allowVolumeOnSlide: true,
        customAspectRatio: 16 / 9, // Standard video aspect ratio
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

    // Seek to saved progress if available
    if (_videoProgress.containsKey(videoUrl)) {
      _videoPlayerController!.seekTo(Duration(
          seconds: (_videoProgress[videoUrl]! *
                  _videoPlayerController!.value.duration.inSeconds)
              .toInt()));
    }

    // Listen to position changes for progress tracking
    _videoPlayerController!.addListener(() {
      final position =
          _videoPlayerController!.value.position.inSeconds.toDouble();
      final duration =
          _videoPlayerController!.value.duration.inSeconds.toDouble();
      if (duration > 0) {
        _saveVideoProgress(videoUrl, position / duration);
      }
    });

    setState(() {
      _selectedVideo = videoUrl;
      _videoPlayerController!.play();
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player (75% width, 2/3 height)
            Expanded(
              flex: 3,
              child: Container(
                height: MediaQuery.of(context).size.height *
                    2 /
                    3, // 2/3 of screen height
                padding:
                    const EdgeInsets.all(16.0), // Padding to avoid sticky edges
                color: Colors.black,
                child: _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: 16 / 9, // Ensure video fills the space
                        child: Stack(
                          children: [
                            CustomVideoPlayer(
                              customVideoPlayerController:
                                  _customVideoPlayerController,
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back,
                                    color: Colors.white, size: 30),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          'اختر فيديو لتشغيله',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
              ),
            ),
            // Gap between video player and list
            SizedBox(width: 16.0),
            // Video List (25% width)
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey[100],
                child: FutureBuilder<List<String>>(
                  future: _videosFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ في تحميل الفيديوهات'));
                    }
                    final videos = snapshot.data!;
                    return ListView.builder(
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final videoUrl = videos[index];
                        final progress = _videoProgress[videoUrl] ?? 0.0;
                        return VideoItem(
                          videoUrl: videoUrl,
                          isSelected: videoUrl == _selectedVideo,
                          onTap: () => _playVideo(videoUrl),
                          progress: progress,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
