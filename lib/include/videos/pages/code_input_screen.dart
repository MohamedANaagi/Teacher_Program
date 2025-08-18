import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/code_bloc.dart';
import '../bloc/code_event.dart';
import '../bloc/code_state.dart';
import 'videos_screen.dart';

class CodeInputScreen extends StatelessWidget {
  final String courseKey;
  final String courseName;
  final TextEditingController _controller = TextEditingController();

  CodeInputScreen({
    required this.courseKey,
    required this.courseName,
    Key? key,
  }) : super(key: key);

  // Function to launch URLs
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400), // Limit width for web
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: BlocConsumer<CodeBloc, CodeState>(
              listener: (context, state) {
                if (state is CodeValid) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideosScreen(courseName: courseName),
                    ),
                    (route) => false,
                  );
                } else if (state is CodeError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    // Title
                    Text(
                      'تسجيل الدخول - $courseName',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Form field
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'كود $courseName',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        errorText: state is CodeError ? state.message : null,
                      ),
                      style: TextStyle(fontSize: 16),
                      onChanged: (_) {
                        if (state is CodeError) {
                          context.read<CodeBloc>().add(ResetCodeState());
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    // Submit button or loading indicator
                    state is CodeLoading
                        ? CircularProgressIndicator(color: Colors.orange)
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            onPressed: () {
                              if (_controller.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('يرجى إدخال الكود',)),
                                );
                                return;
                              }
                              context.read<CodeBloc>().add(
                                    ValidateCode(
                                      code: _controller.text.trim(),
                                      courseName: courseKey,
                                    ),
                                  );
                            },
                            child: Text('تحقق', style: TextStyle(fontSize: 16)),
                          ),
                    SizedBox(height: 30),
                    // No code text
                    Text(
                      'ليس لديك كود دخول؟',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Telegram and WhatsApp buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Telegram
                        GestureDetector(
                          onTap: () => _launchUrl('https://t.me/+201065406332'),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/Telegram_logo.png',
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'كود عبر تليجرام',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 40),
                        // WhatsApp
                        GestureDetector(
                          onTap: () => _launchUrl(
                              'https://wa.me/+201065406332'), // Placeholder WhatsApp link
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/whats app.png',
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'تسجيل عبر واتساب',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
