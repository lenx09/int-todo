import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'home.dart';
class splash extends StatelessWidget {
  const splash({ Key? key }) : super(key: key);

  @override
 Widget build(BuildContext context) {
    return  EasySplashScreen(
      backgroundColor: Colors.amber,
      durationInSeconds:4,
      navigator: home(),
      title: Text('Todo',
      style: TextStyle(
        fontSize:20,
        fontWeight:FontWeight.w700
      ),
      ),
      logo: Image.asset('assets/splash.png',
      width:300,
      height: 300,
      ),
    );
  }
}