import 'package:DeveloperFolio/pages/homepage.dart';
import 'package:DeveloperFolio/pages/layoutpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/widgets.dart';
import 'configure/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
  setupLocator();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   AdaptiveTheme(
      light: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: Colors.amber),
      ),
      dark: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: Colors.amber),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'القائد',
        theme: theme,
        darkTheme: darkTheme,
        home: LayoutTemplate(),
      ),
    );

  }
}
