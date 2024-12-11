import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CenteredView extends StatelessWidget {
  const CenteredView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: const CenteredViewDesk(),
      tablet: const CenteredViewTab(),
      mobile: const CenteredViewMob(),
    );
  }
}

class CenteredViewDesk extends StatelessWidget {
  final Widget? child; // جعل `child` اختيارياً
  const CenteredViewDesk({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 2000),
        child: child,
      ),
    );
  }
}

class CenteredViewMob extends StatelessWidget {
  final Widget? child; // جعل `child` اختيارياً
  const CenteredViewMob({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}

class CenteredViewTab extends StatelessWidget {
  final Widget? child; // جعل `child` اختيارياً
  const CenteredViewTab({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: child,
      ),
    );
  }
}
