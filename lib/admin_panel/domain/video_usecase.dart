import 'package:flutter/foundation.dart';

import '../data_layer/video_repo_impl.dart';

class FetchVideosUseCase {
  final VideosRepository repository;

  FetchVideosUseCase(this.repository);

  Future<List<String>> call(String courseName) {
    return repository.fetchVideos(courseName);
  }
}

class AddVideoUseCase {
  final VideosRepository repository;

  AddVideoUseCase(this.repository);

  Future<void> call(String courseName, String videoName, Uint8List videoData) {
    return repository.addVideo(courseName, videoName, videoData);
  }
}

class EditVideoUseCase {
  final VideosRepository repository;

  EditVideoUseCase(this.repository);
  Future<void> call(String videoPath, String newName) async {
    if (videoPath.isEmpty || newName.isEmpty) {
      throw ArgumentError("Video path and new name must not be empty.");
    }

    await repository.editVideo(videoPath, newName);
  }
}

class DeleteVideoUseCase {
  final VideosRepository repository;

  DeleteVideoUseCase(this.repository);

  Future<void> call(String courseName, String videoName) {
    return repository.deleteVideo(courseName, videoName);
  }
}
