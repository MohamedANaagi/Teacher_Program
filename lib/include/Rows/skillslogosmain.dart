import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

class SkillsLogoDesk extends StatefulWidget {
  const SkillsLogoDesk({Key? key}) : super(key: key);

  @override
  _SkillsLogoDeskState createState() => _SkillsLogoDeskState();
}

class _SkillsLogoDeskState extends State<SkillsLogoDesk>
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'من هو القائد؟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.orange.shade700,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'القائد هو رمز للتميز والإبداع في عالم التعليم والتطوير الشخصي. يحمل رؤية واضحة لتقديم المعرفة بطرق مبتكرة، ويهدف إلى تمكين الأفراد من تحقيق طموحاتهم والوصول إلى أعلى درجات النجاح.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 30),
              SlideTransition(
                position: _slideAnimation,
                child: BulletPoint(
                  text:
                      'القائد في القدرات.. لضمان تحقيق التميز والنجاح بنسبة 100%',
                  icon: Icons.star,
                  iconColor: Colors.orange.shade600,
                ),
              ),
              const SizedBox(height: 15),
              SlideTransition(
                position: _slideAnimation,
                child: BulletPoint(
                  text:
                      'السمات الرئيسية لدورات القائد هي التركيز على تطوير مهارات الطلاب بأساليب مبتكرة',
                  icon: Icons.lightbulb,
                  iconColor: Colors.orange.shade600,
                ),
              ),
              const SizedBox(height: 15),
              SlideTransition(
                position: _slideAnimation,
                child: BulletPoint(
                  text:
                      'حل المسائل بكفاءة عالية، مما يمكنهم من التفوق في القسم الكمي وتحقيق أهدافهم بكل سهولة',
                  icon: Icons.check_circle,
                  iconColor: Colors.orange.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const BulletPoint({
    required this.text,
    required this.icon,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class SkillsLogoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "What i do",
              style: TextStyle(
                  fontWeight: FontWeight.w800, height: 1.0, fontSize: 50),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "CRAZY FULL STACK DEVELOPER WHO WANTS TO EXPLORE EVERY TECH STACK",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.html5,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.css3,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.android,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.python,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.node,
                      size: 60,
                      color: Colors.grey,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.fire,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.react,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.jsSquare,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.database,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.contactBook,
                      size: 60,
                      color: Colors.grey,
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "⚡ Develop highly interactive Front end / User Interfaces for your web and mobile applications",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "⚡ Progressive Web Applications ( PWA ) in normal and SPA Stacks",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "⚡ Integration of third party services such as Firebase/ AWS / Digital Ocean",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillsLogoMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "What i do",
              style: TextStyle(
                  fontWeight: FontWeight.w800, height: 1.0, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "CRAZY FULL STACK DEVELOPER WHO WANTS TO EXPLORE EVERY TECH STACK",
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.html5,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.css3,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.android,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.python,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.fire,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.react,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.jsSquare,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.database,
                      size: 60,
                      color: Colors.grey,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.node,
                      size: 60,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 5,
                ),
                Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      FontAwesomeIcons.contactBook,
                      size: 60,
                      color: Colors.grey,
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "⚡ Develop highly interactive Front end / User Interfaces for your web and mobile applications",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "⚡ Progressive Web Applications ( PWA ) in normal and SPA Stacks",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "⚡ Integration of third party services such as Firebase/ AWS / Digital Ocean",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
