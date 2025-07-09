import 'package:Teacher_Program/configure/centeredview.dart';
import 'package:Teacher_Program/include/CenteringOfPages/ContactCenter.dart';
import 'package:Teacher_Program/include/CenteringOfPages/Education.dart';
import 'package:Teacher_Program/include/Rows/contactpagemain.dart';
import 'package:Teacher_Program/pages/achievementspage.dart';
import 'package:Teacher_Program/pages/blogpage.dart';
import 'package:Teacher_Program/pages/contactpage.dart';
import 'package:Teacher_Program/pages/homepage.dart';
import 'package:Teacher_Program/pages/progresspage.dart';
import 'package:Teacher_Program/pages/skillspage.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

const String SkillsRoute = 'skills';
const String ProjectsRoute = 'projects';
const String EducationRoute = 'education';
const String AchievementsRoute = 'achievements';
const String ContactRoute = 'contact';
const String BlogRoute = 'blogs';
const String HomeRoute = 'Home';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return _getPageRoute(const HomePage(), settings.name!);
    case SkillsRoute:
      return _getPageRoute(
        ScreenTypeLayout(
          desktop: CenteredViewDesk(child:  SkillsPage()),
          tablet: CenteredViewTab(child:  SkillsPage()),
          mobile: CenteredViewMob(child:  SkillsPage()),
        ),
        settings.name!,
      );
    case ProjectsRoute:
      return _getPageRoute(
        ScreenTypeLayout(
          desktop: CenteredViewDesk(child:  BlogPage()),
          tablet: CenteredViewTab(child:  BlogPage()),
          mobile: CenteredViewMob(child:  BlogPage()),
        ),
        settings.name!,
      );
    case EducationRoute:
      return _getPageRoute(
        ScreenTypeLayout(
          desktop: CenteredViewDesk(child:  EducationDesk()),
          tablet: CenteredViewTab(child:  EducationTab()),
          mobile: CenteredViewMob(child:  EducationMob()),
        ),
        settings.name!,
      );
    case AchievementsRoute:
      return _getPageRoute(
        ScreenTypeLayout(
          desktop: CenteredViewDesk(child:  AchievementsPage()),
          tablet: CenteredViewTab(child:  AchievementsPage()),
          mobile: CenteredViewMob(child:  AchievementsPage()),
        ),
        settings.name!,
      );
    case ContactRoute:
      return _getPageRoute(
        ScreenTypeLayout(
          desktop: CenteredViewDesk(child:  ContactPageDesk()),
          tablet: CenteredViewTab(child:  ContactPage()),
          mobile: CenteredViewMob(child:  ContactPage()),
        ),
        settings.name!,
      );
    case BlogRoute:
      return _getPageRoute(
        ScreenTypeLayout(
          desktop: CenteredViewDesk(child:  BlogPage()),
          tablet: CenteredViewTab(child:  BlogPage()),
          mobile: CenteredViewMob(child:  BlogPage()),
        ),
        settings.name!,
      );
    default:
      return _getPageRoute(const HomePage(), settings.name!);
  }
}

PageRoute _getPageRoute(Widget child, String routeName) {
  return _FadeRoute(child: child, routeName: routeName);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;

  _FadeRoute({
    required this.child,
    required this.routeName,
  }) : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    child,
    settings: RouteSettings(name: routeName),
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}
