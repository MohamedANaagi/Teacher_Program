import 'package:Teacher_Program/configure/centeredview.dart';
import 'package:Teacher_Program/configure/navigation_service.dart';
import 'package:Teacher_Program/configure/routing.dart';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'logo/navbarlogo.dart';

class NavbarItem extends StatelessWidget {
  final String title;
  final String navigationPath;

  const NavbarItem(this.title, this.navigationPath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(navigationPath);
      },
      child: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class NavigationBar1 extends StatelessWidget {
  const NavigationBar1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CenteredViewMob(child: NavbarMob()),
      tablet: CenteredViewTab(child: NavbarMob()),
      desktop: CenteredViewDesk(child: NavbarTbDt()),
    );
  }
}

class NavbarTbDt extends StatelessWidget {
  const NavbarTbDt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              html.window.location.reload();
            },
            child: NavbarLogo(),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[


                  NavbarItem('تواصل معنا', ContactRoute),
                  SizedBox(width: 30),

                  NavbarItem('قصة النجاح', BlogRoute),
                  SizedBox(width: 30),

                  NavbarItem('خطوات التسجيل', AchievementsRoute),
                  SizedBox(width: 30),

                  NavbarItem('الباقات', EducationRoute),
                  SizedBox(width: 30),

                  NavbarItem(' عن القائد', SkillsRoute),
                  SizedBox(width: 30),

                  NavbarItem('الرئيسيه', HomeRoute),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      AdaptiveTheme.of(context).toggleThemeMode();
                    },
                    icon: Icon(Icons.brightness_3, size: 25),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavbarMob extends StatelessWidget {
  const NavbarMob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              html.window.location.reload();
            },
            child: NavbarLogo(),
          ),
          Expanded(
            child: Container(
              width: 100,
            ),
          ),
          IconButton(
            alignment: Alignment.topRight,
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
            icon: Icon(Icons.brightness_3, size: 25),
          ),
          IconButton(
            alignment: Alignment.topRight,
            icon: Icon(
              FontAwesomeIcons.bars,
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
