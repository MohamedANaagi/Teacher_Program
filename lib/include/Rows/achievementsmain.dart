import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchieveDesk extends StatefulWidget {
  const AchieveDesk({Key? key}) : super(key: key);

  @override
  _AchieveDeskState createState() => _AchieveDeskState();
}

class _AchieveDeskState extends State<AchieveDesk>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'كيفية التسجيل 📚',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.indigo.shade900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'اتبع هذه الخطوات البسيطة للاشتراك في دورات القائد',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 30),
            StepWidget(
              stepNumber: '01',
              title: 'تسجيل الدخول',
              description: 'قم بتسجيل الدخول باستخدام حساب الطالب الخاص بك',
              icon: Icons.lock,
              backgroundColor: Colors.indigo.shade600,
              slideAnimation: _slideAnimation,
            ),
            const SizedBox(height: 20),
            StepWidget(
              stepNumber: '02',
              title: 'اختر الدورة',
              description: 'تصفح الدورات المتاحة واختر ما يناسبك',
              icon: Icons.book,
              backgroundColor: Colors.indigo.shade500,
              slideAnimation: _slideAnimation,
            ),
            const SizedBox(height: 20),
            StepWidget(
              stepNumber: '03',
              title: 'شراء الدورة',
              description: 'أكمل عملية الدفع بسهولة وسرعة',
              icon: Icons.shopping_cart,
              backgroundColor: Colors.indigo.shade400,
              slideAnimation: _slideAnimation,
            ),
            const SizedBox(height: 20),
            StepWidget(
              stepNumber: '04',
              title: 'أكمل الاشتراك',
              description: 'اضغط على زر الاشتراك لبدء التعلم',
              icon: Icons.account_box,
              backgroundColor: Colors.indigo.shade300,
              slideAnimation: _slideAnimation,
            ),
            const SizedBox(height: 40),
            SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('تواصل معنا'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepWidget extends StatefulWidget {
  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final Animation<Offset> slideAnimation;

  const StepWidget({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.slideAnimation,
    Key? key,
  }) : super(key: key);

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: widget.slideAnimation,
      child: GestureDetector(
        onTap: () {},
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: _isHovered ? 1.03 : 1.0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Text(
                      widget.stepNumber,
                      style: TextStyle(
                        color: widget.backgroundColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.icon,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AchieveTab extends StatefulWidget {
  const AchieveTab({Key? key}) : super(key: key);

  @override
  _AchieveTabState createState() => _AchieveTabState();
}

class _AchieveTabState extends State<AchieveTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'الإنجازات 🏆',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.indigo.shade900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'إنجازات وشهادات وأعمال مميزة قمنا بها',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SlideTransition(
              position: _slideAnimation,
              child: AchievementCard(
                title: 'Walls',
                description: 'Available on Playstore',
                imageUrl:
                    'https://lh3.googleusercontent.com/rSQpAc0Z3nv8cIEub9qYcAbKUvUTelb3HdPhGaToFW6Mqwgap9oqHdXdMaWwYLx44A=s180-rw',
                link:
                    'https://play.google.com/store/apps/details?id=com.naveenjujaray.walls',
                width: 500,
                height: 350,
                imageWidth: 250,
                imageHeight: 175,
              ),
            ),
            const SizedBox(height: 30),
            SlideTransition(
              position: _slideAnimation,
              child: AchievementCard(
                title: 'Blog',
                description: 'Check it out!',
                icon: FontAwesomeIcons.bloggerB,
                iconColor: Colors.redAccent,
                iconSize: 180,
                link: 'https://naveenjujaray.js.org',
                width: 500,
                height: 350,
                imageWidth: 0,
                imageHeight: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchieveMob extends StatefulWidget {
  const AchieveMob({Key? key}) : super(key: key);

  @override
  _AchieveMobState createState() => _AchieveMobState();
}

class _AchieveMobState extends State<AchieveMob>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'الإنجازات 🏆',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.indigo.shade900,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                'إنجازات وشهادات وأعمال مميزة قمنا بها',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: AchievementCard(
                title: 'Walls',
                description: 'Available on Playstore',
                imageUrl:
                    'https://lh3.googleusercontent.com/rSQpAc0Z3nv8cIEub9qYcAbKUvUTelb3HdPhGaToFW6Mqwgap9oqHdXdMaWwYLx44A=s180-rw',
                link:
                    'https://play.google.com/store/apps/details?id=com.naveenjujaray.walls',
                width: 350,
                height: 300,
                imageWidth: 200,
                imageHeight: 125,
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: AchievementCard(
                title: 'Blog',
                description: 'Check it out!',
                icon: FontAwesomeIcons.bloggerB,
                iconColor: Colors.redAccent,
                iconSize: 120,
                link: 'https://naveenjujaray.js.org',
                width: 350,
                height: 300,
                imageWidth: 0,
                imageHeight: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String link;
  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;

  const AchievementCard({
    required this.title,
    required this.description,
    this.imageUrl,
    this.icon,
    this.iconColor,
    this.iconSize,
    required this.link,
    required this.width,
    required this.height,
    required this.imageWidth,
    required this.imageHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        js.context.callMethod("open", [link]);
      },
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.indigo.withOpacity(0.2),
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl!,
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
