import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName) {
    return navigatorKey.currentState?.pushNamed(routeName);
  }

  Future<Object?>? navigateToReplacement(String routeName) {
    return navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
