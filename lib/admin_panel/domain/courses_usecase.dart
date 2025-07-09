import 'package:Teacher_Program/admin_panel/domain/entities.dart';
import '../data_layer/courses_repo_impl.dart';

class FetchCoursesUseCase {
  final CoursesRepository repository;

  FetchCoursesUseCase(this.repository);

  Future<List<String>> call() {
    return repository.fetchCourses();
  }
}

class AddCourseUseCase {
  final CoursesRepository repository;

  AddCourseUseCase(this.repository);

  Future<void> call(String courseName) {
    return repository.addCourse(courseName);
  }
}

class DeleteCourseUseCase {
  final CoursesRepository repository;

  DeleteCourseUseCase(this.repository);

  Future<void> call(String courseName) {
    return repository.deleteCourse(courseName);
  }
}