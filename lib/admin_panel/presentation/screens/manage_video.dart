import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data_layer/video_repo_impl.dart';
import '../../domain/video_usecase.dart';

class VideoManagementScreen extends StatefulWidget {
  final String courseName;

  VideoManagementScreen({required this.courseName});

  @override
  _VideoManagementScreenState createState() => _VideoManagementScreenState();
}

class _VideoManagementScreenState extends State<VideoManagementScreen> {
  late FetchVideosUseCase fetchVideosUseCase;
  late AddVideoUseCase addVideoUseCase;
  late DeleteVideoUseCase deleteVideoUseCase;
  late EditVideoUseCase editVideoUseCase;

  List<Map<String, String>> videos =
[]; 

  @override
  void initState() {
    super.initState();
    // تهيئة الـ Use Cases باستخدام الـ Repositories
    fetchVideosUseCase = FetchVideosUseCase(VideosRepository());
    addVideoUseCase = AddVideoUseCase(VideosRepository());
    deleteVideoUseCase = DeleteVideoUseCase(VideosRepository());
    editVideoUseCase = EditVideoUseCase(VideosRepository());
    loadVideos();
  }

 Future<void> loadVideos() async {
  try {
    final videosList = await fetchVideosUseCase.call(widget.courseName);
    setState(() {
      videos = videosList.map((videoName) => {
            'name': videoName,
            'path': 'courses/${widget.courseName}/videos/$videoName',
          }).toList();
    });
  } catch (e) {
    print('Error loading videos: $e');
  }
}


  Future<void> showEditVideoDialog(String currentName, String videoPath) async {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Video'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Enter new video name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await editVideoUseCase.call(videoPath, nameController.text);
                loadVideos();
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> showAddVideoDialog() async {
  final nameController = TextEditingController();
  Uint8List? videoData;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add New Video'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Enter video name'),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(Icons.video_file),
            label: Text('Choose Video'),
            onPressed: () async {
              // استخدام file_picker لاختيار الفيديو
              final result = await FilePicker.platform.pickFiles(type: FileType.video);
              if (result != null && result.files.single.bytes != null) {
                videoData = result.files.single.bytes!;
                setState(() {}); // تحديث الواجهة إذا أردت إظهار حالة اختيار الفيديو
              }
            },
          ),
          if (videoData != null) Text('Video selected: Ready to upload!'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (nameController.text.isNotEmpty && videoData != null) {
              await addVideoUseCase.call(
                widget.courseName,
                nameController.text,
                videoData!,
              );
              loadVideos();
            } else {
              // رسالة خطأ عند عدم اختيار الفيديو أو إدخال اسم
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter video name and select a video!')),
              );
            }
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Videos')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return ListTile(
                  title: Text(video['name']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            showEditVideoDialog(video['name']!, video['path']!),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await deleteVideoUseCase.call(
                              video['path']!, widget.courseName);
                          loadVideos();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: showAddVideoDialog,
              child: Text('Add New Video'),
            ),
          ),
        ],
      ),
    );
  }
}
