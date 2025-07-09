import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class VideosScreen extends StatefulWidget {
  final String courseName;

  const VideosScreen({required this.courseName});

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late Future<List<String>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = _fetchVideos();
  }

  Future<List<String>> _fetchVideos() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('courses/${widget.courseName}');
    final result = await ref.listAll();

    return await Future.wait(
      result.items.map((item) => item.getDownloadURL()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.courseName),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder<List<String>>(
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
                return VideoItem(videoUrl: videos[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final String videoUrl;

  const VideoItem({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('فيديو ${videoUrl.split('/').last}'),
      leading: Icon(Icons.video_library),
      onTap: () {
        // يمكنك استخدام حزمة مثل video_player لتشغيل الفيديو
      },
    );
  }
}
