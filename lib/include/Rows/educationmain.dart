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

class _EduDeskState extends State<EduDesk> with SingleTickerProviderStateMixin {
  late Future<List<String>> _coursesFuture;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from right
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<List<String>> _fetchCourses() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('courses');
    final result = await ref.listAll();
    return result.prefixes.map((prefix) => prefix.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
      child: Column(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: Text(
              "دورات القائد",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 30),
          FutureBuilder<List<String>>(
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  childAspectRatio: 1.5, // Wider cards
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  mainAxisExtent: 250, // Increased card height
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return SlideTransition(
                    position: _slideAnimation,
                    child: CourseCard(
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
                    ),
                  );
                },
              );
            },
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
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade400],
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
                color: Colors.black.withOpacity(0.2),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.4),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onTap,
                  hoverColor: Colors.blueAccent.withOpacity(0.2),
                  splashColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
