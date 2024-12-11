import 'package:Teacher_Program/configure/centeredview.dart';
import 'package:Teacher_Program/include/CenteringOfPages/Achievement.dart';
import 'package:Teacher_Program/include/CenteringOfPages/Blogcenter.dart';
import 'package:Teacher_Program/include/CenteringOfPages/ContactCenter.dart';
import 'package:Teacher_Program/include/CenteringOfPages/Education.dart';
import 'package:Teacher_Program/include/CenteringOfPages/skills_desk.dart';
import 'package:Teacher_Program/include/Rows/contactpagemain.dart';
import 'package:Teacher_Program/include/Rows/educationmain.dart';
import 'package:Teacher_Program/include/imagesmain/images.dart';
import 'package:Teacher_Program/include/Rows/progressbarmain.dart';
import 'package:Teacher_Program/include/Rows/skillslogosmain.dart';
import 'package:Teacher_Program/include/Rows/welcomepagemain.dart';
import 'package:Teacher_Program/pages/blogpage.dart';
import 'package:Teacher_Program/pages/contactpage.dart';
import 'package:Teacher_Program/pages/educationpage.dart';
import 'package:Teacher_Program/pages/footer.dart';
import 'package:Teacher_Program/pages/progresspage.dart';
import 'package:Teacher_Program/pages/welcome.dart';
import 'package:flutter/material.dart';

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({Key? key}) : super(key: key);

  @override
  _HomeDesktopState createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  var _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                          child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,

                  children: [
                     
                    Row(
                      children: <Widget>[
                        Expanded(child: WelcomePage()),
                        Expanded(child: OneDesk()),

                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: TwoDesk()),
                        Expanded(child: SkillsLogoDesk()),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child: SkillBarDesk()),
                        Expanded(child: ThreeDesk()),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Row(
                      children: [
                        Expanded(child: EducationDesk()),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Row(
                      children: [
                        Expanded(child: AchievementDesk()),
                      ],
                    ),
                     SizedBox(
                      height: 75,
                    ),
                    Row(
                      children: [
                        Expanded(child: BlogCenterDesk()),
                      ],
                    ),
                     SizedBox(
                      height: 75,
                    ),
                     Row(
                      children: [
                        Expanded(child: ContactCenterDesk()),
                        Expanded(child: FourDesk(),),
                      ],
                    ),
                    SizedBox(height: 100,),
                    Row(
                      children: [
                        Expanded(child: FooterPage()),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
                  child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                WelcomePageMob(),
                OneMob(),
                SkillsMob(),
                ProgressPage(),
                EducationMob(),
                AchievementMob(),
                BlogCenterMob(),
                ContactCenterMob(),
                SizedBox(height: 50,),
                FooterPage()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
                  child: ListView(   
                    shrinkWrap: true,     
                    physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                WelcomePageTab(),
                OneTab(),
                SkillsTab(),
                ProgressPage(),
                EducationTab(),
                AchievementTab(),
                BlogCenterTab(),
                ContactCenterTab(),
                SizedBox(height: 50,),
                FooterMob(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
