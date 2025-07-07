import 'package:Teacher_Program/admin_panel/presentation/screens/manage_page.dart';
import 'package:Teacher_Program/configure/navigation_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDJzjzO819YpG3Qo2XlyqzIhjZFt8y9C-Q",
      appId: "1:970628937309:web:9b07bbd38aca6fc6d5bfb4",
      messagingSenderId: "970628937309",
      projectId: "emothions-6e185",
      storageBucket: "emothions-6e185.appspot.com",
    ),
  );


  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyAdminPanel());
}
class MyAdminPanel extends StatelessWidget {
  const MyAdminPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:CourseManagementScreen(),
    );
  }
}
