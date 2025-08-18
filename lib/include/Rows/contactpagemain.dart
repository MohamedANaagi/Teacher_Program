import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ContactPageDesk extends StatefulWidget {
  const ContactPageDesk({Key? key}) : super(key: key);

  @override
  _ContactPageDeskState createState() => _ContactPageDeskState();
}

class _ContactPageDeskState extends State<ContactPageDesk>
    with SingleTickerProviderStateMixin {
  String? _selectedCategory;
  final List<String> _categories = ['الدعم الفني', 'الاستفسار'];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    return Flexible(
      child: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // القسم النصي
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تواصل معنا',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo.shade900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'اختر القسم المناسب لاستفسارك وسنقوم بالرد في أقرب وقت',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.grey.shade50,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              hint: const Text('اختر القسم'),
                              items: _categories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.indigo.shade900,
                              ),
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              if (_selectedCategory != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'تم إرسال الطلب للقسم: $_selectedCategory'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('يرجى اختيار القسم أولاً'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 6,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('إرسال الآن'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // القسم الخاص بالصورة
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/5124556.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'تواصل معنا بسهولة',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'فريقنا جاهز للرد على استفساراتك في أي وقت',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactPageTab extends StatefulWidget {
  const ContactPageTab({Key? key}) : super(key: key);

  @override
  _ContactPageTabState createState() => _ContactPageTabState();
}

class _ContactPageTabState extends State<ContactPageTab>
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
                'تواصل معنا',
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
                'نحن هنا لمساعدتك! تواصل معنا عبر القنوات التالية',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: ContactInfoRow(
                icon: Icons.phone,
                text: '+20 10 6540 6332',
                onTap: () =>
                    js.context.callMethod("open", ["tel:+201065406332"]),
              ),
            ),
            const SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: ContactInfoRow(
                icon: Icons.email,
                text: 'support@qaedcourses.com',
                onTap: () => js.context
                    .callMethod("open", ["mailto:support@qaedcourses.com"]),
              ),
            ),
            const SizedBox(height: 30),
            SlideTransition(
              position: _slideAnimation,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 15,
                children: [
                  SocialIconButton(
                    icon: FontAwesomeIcons.telegram,
                    color: Colors.blue,
                    onPressed: () => js.context
                        .callMethod("open", ["https://t.me/+201065406332"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    onPressed: () => js.context
                        .callMethod("open", ["https://wa.me/+201065406332"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.facebook,
                    color: Colors.blue,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.facebook.com/naveenjujaray"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.twitter,
                    color: Colors.lightBlue,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://twitter.com/naveenjujaray"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.linkedin,
                    color: const Color.fromRGBO(40, 103, 178, 1),
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.linkedin.com/in/naveenjujaray"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.bloggerB,
                    color: Colors.red,
                    onPressed: () => js.context
                        .callMethod("open", ["https://naveenjujaray.js.org"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.github,
                    color: Colors.black,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.github.com/naveenjujaray"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.gitlab,
                    color: Colors.orange,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.gitlab.com/naveenjujaray"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.medium,
                    color: Colors.black,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://medium.com/@naveenjujaray"]),
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.reddit,
                    color: Colors.deepOrangeAccent,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.reddit.com/user/jujaraynaveen"]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactPageMob extends StatefulWidget {
  const ContactPageMob({Key? key}) : super(key: key);

  @override
  _ContactPageMobState createState() => _ContactPageMobState();
}

class _ContactPageMobState extends State<ContactPageMob>
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
                'تواصل معنا',
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
                'نحن هنا لمساعدتك! تواصل معنا عبر القنوات التالية',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: ContactInfoRow(
                icon: Icons.phone,
                text: '+20 10 6540 6332',
                onTap: () =>
                    js.context.callMethod("open", ["tel:+201065406332"]),
              ),
            ),
            const SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimation,
              child: ContactInfoRow(
                icon: Icons.email,
                text: 'support@qaedcourses.com',
                onTap: () => js.context
                    .callMethod("open", ["mailto:support@qaedcourses.com"]),
              ),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideAnimation,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  SocialIconButton(
                    icon: FontAwesomeIcons.telegram,
                    color: Colors.blue,
                    onPressed: () => js.context
                        .callMethod("open", ["https://t.me/+201065406332"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.whatsapp,
                    color: Colors.green,
                    onPressed: () => js.context
                        .callMethod("open", ["https://wa.me/+201065406332"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.facebook,
                    color: Colors.blue,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.facebook.com/naveenjujaray"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.twitter,
                    color: Colors.lightBlue,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://twitter.com/naveenjujaray"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.linkedin,
                    color: const Color.fromRGBO(40, 103, 178, 1),
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.linkedin.com/in/naveenjujaray"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.bloggerB,
                    color: Colors.red,
                    onPressed: () => js.context
                        .callMethod("open", ["https://naveenjujaray.js.org"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.github,
                    color: Colors.black,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.github.com/naveenjujaray"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.gitlab,
                    color: Colors.orange,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.gitlab.com/naveenjujaray"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.medium,
                    color: Colors.black,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://medium.com/@naveenjujaray"]),
                    size: 35,
                  ),
                  SocialIconButton(
                    icon: FontAwesomeIcons.reddit,
                    color: Colors.deepOrangeAccent,
                    onPressed: () => js.context.callMethod(
                        "open", ["https://www.reddit.com/user/jujaraynaveen"]),
                    size: 35,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ContactInfoRow({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.indigo.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.indigo.shade600,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.indigo.shade900,
                fontSize: 16,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const SocialIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 40,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: size,
      ),
      onPressed: onPressed,
      padding: const EdgeInsets.all(10),
      splashRadius: 25,
      tooltip: icon.toString().split('.').last,
    );
  }
}
