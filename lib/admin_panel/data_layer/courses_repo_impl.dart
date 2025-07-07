import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CoursesRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<String>> fetchCourses() async {
    final ListResult result = await storage.ref('courses').listAll();
    return result.prefixes.map((ref) => ref.name).toList();
  }

  Future<void> addCourse(String courseName) async {
    await storage.ref('courses/$courseName/').putData(Uint8List(0)); // Creates an empty folder
  }

  Future<void> deleteCourse(String courseName) async {
    final ListResult result = await storage.ref('courses/$courseName').listAll();
    for (var item in result.items) {
      await item.delete();
    }
    for (var folder in result.prefixes) {
      await deleteCourse('$courseName/${folder.name}');
    }
    await storage.ref('courses/$courseName').delete();
  }
}