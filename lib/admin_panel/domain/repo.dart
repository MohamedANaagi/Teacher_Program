import 'dart:io';

import 'entities.dart';

abstract class StorageRepository {
  Future<List<Course>> getCourses();
  Future<void> addCourse(String courseName);
  Future<void> deleteCourse(String coursePath);
  Future<List<Video>> getVideos(String courseName);
  Future<void> addVideo(String courseName, String videoName, File file);
  Future<void> deleteVideo(String videoPath);
  Future<void> updateVideo(String courseName, String videoPath, String newName, File? newFile);
}
