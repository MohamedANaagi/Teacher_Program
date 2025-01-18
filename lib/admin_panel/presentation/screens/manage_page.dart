import 'package:Teacher_Program/admin_panel/data_layer/courses_repo_impl.dart';
import 'package:Teacher_Program/admin_panel/domain/use_cases.dart';
import 'package:flutter/material.dart';

class CourseManagementScreen extends StatefulWidget {
  @override
  _CourseManagementScreenState createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  late FetchCoursesUseCase fetchCoursesUseCase;
  late AddCourseUseCase addCourseUseCase;
  late DeleteCourseUseCase deleteCourseUseCase;

  List<String> courses = []; // تعديل النوع بما يتناسب مع البيانات القادمة من Firebase Storage

  @override
  void initState() {
    super.initState();
    // تهيئة الـ Use Cases باستخدام الـ Repositories
    fetchCoursesUseCase = FetchCoursesUseCase(CoursesRepository());
    addCourseUseCase = AddCourseUseCase(CoursesRepository());
    deleteCourseUseCase = DeleteCourseUseCase(CoursesRepository());
    loadCourses();
  }

  Future<void> loadCourses() async {
    final result = await fetchCoursesUseCase.execute();
    setState(() {
      courses = result as List<String>;
    });
  }

  Future<void> showAddCourseDialog() async {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Course'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter course name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await addCourseUseCase.execute(controller.text);
                loadCourses();
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
      appBar: AppBar(title: Text('Manage Courses')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await deleteCourseUseCase.execute(course);
                      loadCourses();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: showAddCourseDialog,
              child: Text('Add New Course'),
            ),
          ),
        ],
      ),
    );
  }
}
