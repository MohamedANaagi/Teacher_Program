import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:Teacher_Program/admin_panel/data_layer/courses_repo_impl.dart';
import 'package:Teacher_Program/admin_panel/data_layer/video_repo_impl.dart';
import 'package:Teacher_Program/admin_panel/domain/entities.dart';
import 'package:flutter/foundation.dart';

class FetchCoursesUseCase {
  final CoursesRepository repository;

  FetchCoursesUseCase(this.repository);

  Future<List<Course>> execute() async {
    return await repository.call();
  }
}

class AddCourseUseCase {
  final CoursesRepository repository;

  AddCourseUseCase(this.repository);

  Future<void> execute(String courseName) async {
    await repository.addCourse(courseName);
  }
}

class DeleteCourseUseCase {
  final CoursesRepository repository;

  DeleteCourseUseCase(this.repository);

  Future<void> execute(String coursePath) async {
    await repository.deleteCourse(coursePath);
  }
}

class FetchVideosUseCase {
  final VideosRepository repository;

  FetchVideosUseCase(this.repository);

  Future<List<String>> execute(String courseName) async {
    return await repository.fetchVideos(courseName);
  }
}

class AddVideoUseCase {
  final VideosRepository repository;

  AddVideoUseCase(this.repository);

  Future<void> execute(String courseName, String videoName, Uint8List file) async {
    await repository.addVideo(courseName, videoName, file);
  }
}

class DeleteVideoUseCase {
  final VideosRepository repository;

  DeleteVideoUseCase(this.repository);

  Future<void> execute(String coursename,String videoname) async {
    await repository.deleteVideo(coursename,videoname);
  }
}

class UpdateVideoUseCase {
  final VideosRepository repository;

  UpdateVideoUseCase(this.repository);

  Future<void> execute(String courseName, String videoPath, String newName, File? newFile) async {
    await repository.editVideo(videoPath,newName , newFile );
  }
}
