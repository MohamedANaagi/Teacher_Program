import 'package:Teacher_Program/configure/colors.dart';
import 'package:flutter/material.dart';

class OneDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 700,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child:
            Image.asset('assets/images/Book_Club_Logo-removebg-preview.png'));
  }
}

class OneMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 800,
        alignment: Alignment.center,
        child: Image.asset('assets/images/one.png'));
  }
}

class OneTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 600, child: Image.asset('assets/images/one.png'));
  }
}

class TwoDesk extends StatefulWidget {
  const TwoDesk({Key? key}) : super(key: key);

  @override
  _TwoDeskState createState() => _TwoDeskState();
}

class _TwoDeskState extends State<TwoDesk> with SingleTickerProviderStateMixin {
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
    return Center(
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/freepik__a-middleaged-caucasian-man-with-short-dark-hair-an__48050.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 400, // Fixed height for consistency
            ),
          ),
        ),
      ),
    );
  }
}

class TwoMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 800,
        alignment: Alignment.center,
        child: Image.asset('assets/images/two.png'));
  }
}

class TwoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 600, child: Image.asset('assets/images/two.png'));
  }
}

class ThreeDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 600,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Image.asset('assets/images/three.png'));
  }
}

class ThreeMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 800,
        alignment: Alignment.center,
        child: Image.asset('assets/images/three.png'));
  }
}

class ThreeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 600, child: Image.asset('assets/images/three.png'));
  }
}

class FourDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

        //   width: 600,
        //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //   child: Image.asset('assets/images/5124556.jpg')
        //
        );
  }
}

class FourMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 800,
        alignment: Alignment.center,
        child: Image.asset('assets/images/four.png'));
  }
}

class FourTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 600, child: Image.asset('assets/images/four.png'));
  }
}
