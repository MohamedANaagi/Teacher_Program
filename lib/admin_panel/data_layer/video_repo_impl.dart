import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class VideosRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<String>> fetchVideos(String courseName) async {
    final ListResult result = await storage.ref('courses/$courseName/videos').listAll();
    return result.items.map((ref) => ref.name).toList();
  }

  Future<void> addVideo(String courseName, String videoName, Uint8List videoData) async {
    await storage.ref('courses/$courseName/videos/$videoName').putData(videoData);
  }

  Future<void> deleteVideo(String courseName, String videoName) async {
    await storage.ref('courses/$courseName/videos/$videoName').delete();
  }

Future<void> editVideo(String videoPath, String newName, [File? newVideoFile]) async {
  final Reference ref = storage.ref(videoPath);

  try {
    // تحديث الفيديو إذا تم تمرير ملف جديد
    if (newVideoFile != null) {
      final newRef = storage.ref().child('videos/$newName'); // إنشاء مرجع جديد
      await newRef.putFile(newVideoFile); // رفع الفيديو الجديد
      await ref.delete(); // حذف الفيديو القديم
    }

    // تحديث البيانات الوصفية لتحديث الاسم فقط
    final metadata = SettableMetadata(customMetadata: {'name': newName});
    await ref.updateMetadata(metadata);
  } catch (e) {
    throw Exception("Failed to edit video: $e");
  }
}

  }
