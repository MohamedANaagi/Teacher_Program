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

  const NavbarItem(this.title, this.navigationPath, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<NavigationService>().navigateTo(navigationPath);
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.indigo.shade900,
          fontWeight: FontWeight.w600,
        ),
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

class NavbarTbDt extends StatefulWidget {
  const NavbarTbDt({Key? key}) : super(key: key);

  @override
  _NavbarTbDtState createState() => _NavbarTbDtState();
}

class _NavbarTbDtState extends State<NavbarTbDt>
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
    final screenWidth = MediaQuery.of(context).size.width;
    // Adjust spacing based on screen width
    final itemSpacing = screenWidth > 1200
        ? 30.0
        : screenWidth > 800
            ? 20.0
            : 15.0;
    // Constrain navbar width for large screens
    final navbarMaxWidth = screenWidth > 1400 ? 1400.0 : screenWidth * 0.95;

    return Container(
      height: 70,
      constraints: BoxConstraints(maxWidth: navbarMaxWidth),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                html.window.location.reload();
              },
              child: NavbarLogo(),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NavbarItem('تواصل معنا', ContactRoute),
                      SizedBox(width: itemSpacing),
                      NavbarItem('خطوات التسجيل', AchievementsRoute),
                      SizedBox(width: itemSpacing),
                      NavbarItem('الباقات', EducationRoute),
                      SizedBox(width: itemSpacing),
                      NavbarItem('عن القائد', SkillsRoute),
                      SizedBox(width: itemSpacing),
                      NavbarItem('الرئيسية', HomeRoute),
                      SizedBox(width: itemSpacing),
                      IconButton(
                        onPressed: () {
                          AdaptiveTheme.of(context).toggleThemeMode();
                        },
                        icon: Icon(
                          Icons.brightness_3,
                          size: 25,
                          color: Colors.indigo.shade900,
                        ),
                        tooltip: 'تبديل الوضع',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
