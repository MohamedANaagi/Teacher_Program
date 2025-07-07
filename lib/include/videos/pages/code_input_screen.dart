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
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول - $courseName'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'أدخل كود $courseName',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                if (state is CodeLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<CodeBloc>().add(
                            ValidateCode(
                              code: _controller.text,
                              courseName: courseKey,
                            ),
                          );
                    },
                    child: Text('تحقق'),
                  ),
                if (state is CodeError)
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
