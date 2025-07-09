import 'package:Teacher_Program/configure/routing.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../navigationbar.dart';


class NavigationDrawer1 extends StatelessWidget {
  const NavigationDrawer1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: Container(
        width: 300,
       
        child: Column(
          children: <Widget>[
            DrawerItem('الرئيسيه', FontAwesomeIcons.home, HomeRoute),
            DrawerItem('معلومات عن القائد', FontAwesomeIcons.tasks, SkillsRoute),
            DrawerItem('الكورسات', FontAwesomeIcons.graduationCap, EducationRoute),
            DrawerItem('خطوات التسجيل', FontAwesomeIcons.folderOpen, ProjectsRoute),
            DrawerItem('الباقات',FontAwesomeIcons.trophy, AchievementsRoute),
            DrawerItem('قصص النجاح',FontAwesomeIcons.bloggerB, BlogRoute),
            DrawerItem('تواصل معنا', FontAwesomeIcons.user, ContactRoute),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String navigationPath;
  const DrawerItem(this.title, this.icon, this.navigationPath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 60),
      child: Row(
        children: <Widget>[
         Icon(icon),
          SizedBox(
            width: 30,
          ),
          NavbarItem(title,navigationPath),
        ],
      ),
    );
  }
}