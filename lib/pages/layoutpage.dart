import 'package:Teacher_Program/configure/centeredview.dart';
import 'package:Teacher_Program/configure/navigation_service.dart';
import 'package:Teacher_Program/include/navbar/drawer/drawernav.dart';
import 'package:Teacher_Program/include/navbar/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:Teacher_Program/configure/routing.dart';

class LayoutTemplate extends StatelessWidget {
  const LayoutTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        endDrawer: const NavigationDrawer1(),
        endDrawerEnableOpenDragGesture: false,
        body: Column(
          children: [
            const NavigationBar1(),
            Expanded(
              child: Navigator(
                key: locator<NavigationService>().navigatorKey,
                onGenerateRoute: generateRoute,
                initialRoute: HomeRoute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
