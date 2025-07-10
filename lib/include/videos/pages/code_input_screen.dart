import 'package:Teacher_Program/include/videos/pages/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/code_bloc.dart';
import '../bloc/code_event.dart';
import '../bloc/code_state.dart';

class CodeInputScreen extends StatelessWidget {
  final String courseKey;
  final String courseName;
  final TextEditingController _controller = TextEditingController();

  CodeInputScreen({
    required this.courseKey,
    required this.courseName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول - $courseName'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocConsumer<CodeBloc, CodeState>(
        listener: (context, state) {
          if (state is CodeValid) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => VideosScreen(courseName: courseName),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'أدخل كود الدورة',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'كود $courseName',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                SizedBox(height: 20),
                if (state is CodeLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      context.read<CodeBloc>().add(
                            ValidateCode(
                              code: _controller.text,
                              courseName: courseKey,
                            ),
                          );
                    },
                    child: Text('تحقق', style: TextStyle(fontSize: 18)),
                  ),
                if (state is CodeError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
