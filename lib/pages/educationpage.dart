import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:Teacher_Program/include/Rows/educationmain.dart';

import '../include/CenteringOfPages/Education.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: const EducationDesk(),
      tablet: const EducationTab(),
      mobile: const EducationMob(),
    );
  }
}
