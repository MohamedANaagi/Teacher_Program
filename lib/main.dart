// import 'package:Teacher_Program/pages/homepage.dart';
// import 'package:Teacher_Program/pages/layoutpage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'configure/navigation_service.dart';
// import 'firebase_options.dart';
// // import 'include/course/cubits/course_cubit.dart';
// // import 'include/course/screens/course_screen.dart';
// // import 'include/course/services/course_services.dart';
// import 'include/register/cubits/registration_cubit.dart';
// import 'include/register/screens/courses_screen.dart';
// import 'include/register/screens/register_screen.dart';
// import 'include/register/services/firestore_services.dart';
// import 'include/register/services/shared_prefrences_services.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(
//     options:
//         DefaultFirebaseOptions.currentPlatform, // إذا كان لديك ملف تكوين منفصل
//
//     // options: const FirebaseOptions(
//     //   apiKey: 'AIzaSyDJzjzO819YpG3Qo2XlyqzIhjZFt8y9C-Q',
//     //   appId: '1:970628937309:web:9b07bbd38aca6fc6d5bfb4',
//     //   messagingSenderId: '970628937309',
//     //   projectId: 'emothions-6e185',
//     //   authDomain: 'emothions-6e185.firebaseapp.com',
//     //   storageBucket: 'emothions-6e185.appspot.com',
//     // ),
//   );
//
//   final savedThemeMode = await AdaptiveTheme.getThemeMode();
//   final isRegistered = await LocalCache().isRegistered();
//
//   setupLocator();
//
//   runApp(MyApp(
//     savedThemeMode: savedThemeMode,
//     isRegistered: isRegistered,
//   ));
// }
//
// class MyApp extends StatelessWidget {
//   final AdaptiveThemeMode? savedThemeMode;
//   final bool isRegistered;
//
//   const MyApp({
//     Key? key,
//     this.savedThemeMode,
//     required this.isRegistered,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // BlocProvider(
//         //   create: (context) => CoursesCubit(
//         //     courseService: CourseService(),
//         //   ),
//         // ),
//         BlocProvider(
//             create: (context) => RegistrationCubit(
//                   firestoreService: FirestoreService(),
//                   localCache: LocalCache(),
//                 )),
//       ],
//       child: AdaptiveTheme(
//         light: ThemeData(
//           primarySwatch: Colors.red,
//           colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
//               .copyWith(secondary: Colors.amber),
//           textTheme: GoogleFonts.cairoTextTheme(),
//         ),
//         dark: ThemeData(
//           primarySwatch: Colors.red,
//           colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
//               .copyWith(secondary: Colors.amber),
//           textTheme: GoogleFonts.cairoTextTheme().apply(
//             bodyColor: Colors.white,
//             displayColor: Colors.white,
//           ),
//         ),
//         initial: savedThemeMode ?? AdaptiveThemeMode.light,
//         builder: (theme, darkTheme) => MaterialApp(
//           //  navigatorKey: locator<NavigationService>().navigatorKey,
//           onGenerateRoute: (settings) {
//             if (settings.name == '/courses') {
//               return PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const CoursesScreen(),
//                 transitionDuration: Duration.zero,
//               );
//             }
//             return null;
//           },
//
//           debugShowCheckedModeBanner: false,
//           title: 'القائد',
//           theme: theme,
//           darkTheme: darkTheme,
//           home: isRegistered ? LayoutTemplate() : RegistrationScreen(),
//           navigatorKey: locator<NavigationService>().navigatorKey,
//         ),
//       ),
//     );
//   }
// }
import 'package:Teacher_Program/pages/homepage.dart';
import 'package:Teacher_Program/pages/layoutpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configure/navigation_service.dart';
import 'firebase_options.dart';
import 'include/videos/bloc/code_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // إذا كان لديك ملف تكوين منفصل

    // options: const FirebaseOptions(
    //   apiKey: 'AIzaSyDJzjzO819YpG3Qo2XlyqzIhjZFt8y9C-Q',
    //   appId: '1:970628937309:web:9b07bbd38aca6fc6d5bfb4',
    //   messagingSenderId: '970628937309',
    //   projectId: 'emothions-6e185',
    //   authDomain: 'emothions-6e185.firebaseapp.com',
    //   storageBucket: 'emothions-6e185.appspot.com',
    // ),
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isRegistered = prefs.getBool('isRegistered') ?? false;
  final bool isRegistered1 = prefs.getBool('isRegistered1') ?? false;
  final bool isRegistered2 = prefs.getBool('isRegistered2') ?? false;

  final AdaptiveThemeMode? savedThemeMode = await AdaptiveTheme.getThemeMode();
  setupLocator();
  runApp(MyApp(
    savedThemeMode: savedThemeMode,
    isRegistered: isRegistered,
  ));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  final bool isRegistered;
  const MyApp({Key? key, this.savedThemeMode, required this.isRegistered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CodeBloc(),
        ),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              .copyWith(secondary: Colors.amber),
        ),
        dark: ThemeData(
          scaffoldBackgroundColor: Colors.black54,
          primarySwatch: Colors.red,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red)
              .copyWith(secondary: Colors.amber),
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'القائد',
          theme: theme,
          darkTheme: darkTheme,
          home: LayoutTemplate(),
        ),
      ),
    );
  }
}
