// // Data Layer

// // Datasource
// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';

// class FirebaseStorageDatasource {
//   final FirebaseStorage _storage;

//   FirebaseStorageDatasource(this._storage);

//   Future<List<Map<String, dynamic>>> fetchCourses() async {
//     final ListResult result = await _storage.ref().listAll();
//     return result.prefixes.map((prefix) => {
//       'name': prefix.name,
//       'path': prefix.fullPath,
//     }).toList();
//   }

//   Future<void> addCourse(String courseName) async {
//     final courseRef = _storage.ref(courseName);
//     await courseRef.putString(''); // Create an empty file
//   }

//   Future<void> deleteCourse(String coursePath) async {
//     final courseRef = _storage.ref(coursePath);
//     await courseRef.delete();
//   }

//   Future<List<Map<String, dynamic>>> fetchVideos(String courseName) async {
//     final ListResult result = await _storage.ref(courseName).listAll();
//     return result.items.map((item) => {
//       'name': item.name,
//       'path': item.fullPath,
//     }).toList();
//   }

//   Future<void> addVideo(String courseName, String videoName, File file) async {
//     final videoRef = _storage.ref('$courseName/$videoName');
//     await videoRef.putFile(file);
//   }

//   Future<void> deleteVideo(String videoPath) async {
//     final videoRef = _storage.ref(videoPath);
//     await videoRef.delete();
//   }

//   Future<void> updateVideo(String courseName, String videoPath, String newName, File? newFile) async {
//     final videoRef = _storage.ref(videoPath);

//     if (newFile != null) {
//       await videoRef.putFile(newFile);
//     }

//     if (newName.isNotEmpty) {
//       final newVideoRef = _storage.ref('$courseName/$newName');
//       await videoRef.copy(newVideoRef.fullPath);
//       await videoRef.delete();
//     }
//   }
// }
