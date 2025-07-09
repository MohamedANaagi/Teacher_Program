import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AchieveDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepWidget(
              stepNumber: '01',
              title: 'قم بتسجيل الدخول على الموقع',
              description: 'تسجيل الدخول من خلال حساب الطالب',
              icon: Icons.lock,
              backgroundColor: Colors.indigo.shade400,
            ),
            SizedBox(height: 16),
            StepWidget(
              stepNumber: '02',
              title: 'اختر الدورة التي ترغب في الاشتراك بها',
              description: 'وتعرف على تفاصيلها',
              icon: Icons.book,
              backgroundColor: Colors.indigo.shade300,
            ),
            SizedBox(height: 16),
            StepWidget(
              stepNumber: '03',
              title: 'اضغط على "شراء الدورة"',
              description: 'واكمل إجراءات الدفع',

              icon: Icons.shopping_cart,
              backgroundColor: Colors.indigo.shade200,
            ),
            SizedBox(height: 16),
            StepWidget(
              stepNumber: '04',
              title: 'أكمل عملية الاشتراك',
              description: 'من خلال الضغط على الزر المخصص لذلك',
              icon: Icons.account_box,
              backgroundColor: Colors.indigo.shade100,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("تواصل معنا",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class StepWidget extends StatefulWidget {
  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;

  const StepWidget({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // يمكنك إضافة التأثيرات التفاعلية هنا
      },
      child: InkWell(
        onHover: (isHovering) {
          setState(() {
            _isHovered = isHovering;
          });
        },
        splashColor: Colors.white30,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedScale(
          duration: Duration(milliseconds: 200),
          scale: _isHovered ? 1.05 : 1.0, // تغيير الحجم عند التحويم
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.stepNumber,
                    style: TextStyle(
                      color: widget.backgroundColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(widget.icon, color: widget.backgroundColor),
                          SizedBox(width: 8),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AchieveTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements 🏆', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 50),),
            SizedBox(height: 10,),
            Text('ACHIEVEMENTS, CERTIFICATIONS AND SOME COOL STUFF THAT I HAVE DONE !',
            style: TextStyle(color: Colors.grey, fontSize: 22),),
            SizedBox(height: 25,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Container(
                        width: 450,
                        height: 300,
                         padding: new EdgeInsets.fromLTRB(20,20,20,20),
                        decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [new BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 5,
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
              ),
 
                    ),]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  Image.network('https://lh3.googleusercontent.com/rSQpAc0Z3nv8cIEub9qYcAbKUvUTelb3HdPhGaToFW6Mqwgap9oqHdXdMaWwYLx44A=s180-rw',width: 250, height: 175,),
                  Text('Walls',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                  InkWell(
                    onTap: () {
                       js.context.callMethod("open", ["https://play.google.com/store/apps/details?id=com.naveenjujaray.walls"]);
                    },
                    child: Text('Available on Playstore',style: TextStyle(fontSize: 18, color: Colors.green[900]),textAlign: TextAlign.center,)),
            ],
          ),
                      ),
                       SizedBox(height: 25,),
                      Container(
                        width: 450,
                        height: 300,
                         padding: new EdgeInsets.fromLTRB(20,20,20,20),
                        decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [new BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 5,
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
              ),
                    ),]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  Icon(FontAwesomeIcons.bloggerB,size: 170, color: Colors.redAccent,),
                  SizedBox(height: 5,),
                  Text('Blog',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                  InkWell(
                    onTap: () {
                       js.context.callMethod("open", ["https://naveenjujaray.js.org"]);
                    },
                    child: Text('Check it out !',style: TextStyle(fontSize: 18, color: Colors.green[900]),textAlign: TextAlign.center,)),
            ],
          ),
                      ),
                      SizedBox(height: 25,),
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

class AchieveMob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Container(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements 🏆', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32),),
            SizedBox(height: 10,),
            Text('ACHIEVEMENTS, CERTIFICATIONS AND SOME COOL STUFF THAT I HAVE DONE !',
            style: TextStyle(color: Colors.grey, fontSize: 18),),
            SizedBox(height: 25,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Container(
                        width: 400,
                        height: 250,
                         padding: new EdgeInsets.fromLTRB(20,20,20,20),
                        decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [new BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 5,
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
              ),
 
                    ),]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  Image.network('https://lh3.googleusercontent.com/rSQpAc0Z3nv8cIEub9qYcAbKUvUTelb3HdPhGaToFW6Mqwgap9oqHdXdMaWwYLx44A=s180-rw',width: 200, height: 125,),
                  Text('Walls',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                  InkWell(
                    onTap: () {
                       js.context.callMethod("open", ["https://play.google.com/store/apps/details?id=com.naveenjujaray.walls"]);
                    },
                    child: Text('Available on Playstore',style: TextStyle(fontSize: 18, color: Colors.green[900]),textAlign: TextAlign.center,)),
            ],
          ),
                      ),
                       SizedBox(height: 25,),
                      Container(
                        width: 400,
                        height: 250,
                         padding: new EdgeInsets.fromLTRB(20,20,20,20),
                        decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white.withOpacity(0.5),
                    boxShadow: [new BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        spreadRadius: 5,
                        offset: Offset(
                          5.0, // Move to right 10  horizontally
                          5.0, // Move to bottom 10 Vertically
              ),
                    ),]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                  Icon(FontAwesomeIcons.bloggerB,size: 120, color: Colors.redAccent,),
                  SizedBox(height: 5,),
                  Text('Blog',style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                  InkWell(
                    onTap: () {
                       js.context.callMethod("open", ["https://naveenjujaray.js.org"]);
                    },
                    child: Text('Check it out !',style: TextStyle(fontSize: 18, color: Colors.green[900]),textAlign: TextAlign.center,)),
            ],
          ),
                      ),
                      SizedBox(height: 25,),
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