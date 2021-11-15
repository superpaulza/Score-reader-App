import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:score_scanner/modules/themechanger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class aboutPage extends StatefulWidget {
  aboutPage({Key? key}) : super(key: key);

  @override
  _aboutPageState createState() => _aboutPageState();
}

class _aboutPageState extends State<aboutPage> {
  bool _isEnableGayRay = false;
  SharedPreferences? preferences;

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete((){
       setState(() {});
     });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isEnableGayRay = (preferences!.getBool('isEGayRay') ?? false);

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              child: Image.asset('assets/img/No_AI_bullet_curve.png'),
              onLongPress: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Successfully enable G R A Y R A Y Developer Mode!'),
                  duration: const Duration(seconds: 2),
                  ));
                  setState(() {
                    _isEnableGayRay = true;
                    this.preferences?.setBool("isEGayRay", _isEnableGayRay);
                  });
              },
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "\nNo AI Bullet Curve Team\n",
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  // WidgetSpan(
                  //   child: Icon(Icons.camera_alt, size: 20),
                  // ),
                  TextSpan(
                    text: "\nPresent\n\n",       
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n\nNBC Score Scanner\nVersion Beta Release v.0.0.1 \n(codename: Jai- G R A Y - R A Y)\n",       
                  ),
                  TextSpan(
                    text: "\nThis app is part of AI mini-project\n@CS-KMITL 2021\n",       
                  ),
                  TextSpan(
                    text: "\nUsing Tflite for running an AI model \n(named: NoAIBulletCurve)\n",       
                  ),
                  TextSpan(
                    text: "\nUsing Flutter for very",       
                  ),
                  TextSpan(
                    text: "\n\"G R A Y R A Y\"\n",
                    style: TextStyle(fontWeight: FontWeight.bold)       
                  ),
                  TextSpan(
                    text: "app interface\n",       
                  ),
                  TextSpan(
                    text: "\nThank everyone who make this project\n",       
                  ),
                  TextSpan(
                    text: "complete before the deadline\n",       
                  ),
                  TextSpan(
                    text: "especially \'StackOverFlow\'\n",       
                  ),
                  TextSpan(
                    text: "\nNo AI Bullet Curve Team Member\n\n",
                    style: TextStyle(fontWeight: FontWeight.bold)          
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050198 \nนายพฤกษ์ ตั้งวงศ์เจริญกิจ\n\n",
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050199 \nนายพล หอชัยเจริญ\n\n",       
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050220 \nนายวรปัญญา บุญมาก\n\n",       
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050222 \nนายวิทยา วรจันทร์เพ็ญศรี\n\n",       
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050243 \nนายหฤษฎ์ ชวลิตเบญจ\n\n",       
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050245 \nนายอภิชัย สมุทรทอง\n\n",       
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'assets/img/icon.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                  TextSpan(
                    text: "\n62050250 \nนายอี้วเต๋อ หลิน\n",       
                  ),
                  TextSpan(
                    text: "\nMade with\n",       
                  ),
                  WidgetSpan(
                    child: Icon(Icons.favorite, size: 20,)
                  ),
                  TextSpan(
                    text: "\n\"Jai- G R A Y R A Y\"\n",
                    style: TextStyle(fontWeight: FontWeight.bold)       
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );

  }
}