import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html;
import 'package:Teacher_Program/include/videos/pages/code_input_screen.dart';
import 'package:Teacher_Program/include/videos/pages/videos_screen.dart';

class EduDesk extends StatefulWidget {
  const EduDesk({Key? key}) : super(key: key);

  @override
  _EduDeskState createState() => _EduDeskState();
}

class _EduDeskState extends State<EduDesk> {
  late Future<List<String>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  Future<List<String>> _fetchCourses() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('courses');
    final result = await ref.listAll();
    return result.prefixes.map((prefix) => prefix.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "دورات القائد",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 20),
          // Removed Expanded and added a SizedBox with constrained height
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust height as needed
            child: FutureBuilder<List<String>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('حدث خطأ في تحميل الكورسات'));
                }
                final courses = snapshot.data!;
                return GridView.builder(
                  shrinkWrap:
                      true, // Ensure GridView takes only the space it needs
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(
                      title: course,
                      imagePath:
                          'assets/images/Book_Club_Logo-removebg-preview.png',
                      onTap: () async {
                        final isRegistered = html.window
                                .localStorage['isRegistered_${course}'] ==
                            'true';
                        if (isRegistered) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VideosScreen(courseName: course),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CodeInputScreen(
                                courseName: course,
                                courseKey: course,
                              ),
                            ),
                          );
                        }
                      },
                      key: UniqueKey(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const CourseCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.1),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
