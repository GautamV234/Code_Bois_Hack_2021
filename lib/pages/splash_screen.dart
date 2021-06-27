import 'package:code_bois/pages/splash.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen2 extends StatefulWidget {
  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
      // final prefs = await SharedPreferences.getInstance();
      // final signedInStatus = prefs.getBool('signedInStatus');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width / 5,
              child: Image.asset(
                "assets/asset_1.jpg",
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 25.7125,
                  MediaQuery.of(context).size.width / 51.425,
                  MediaQuery.of(context).size.width / 25.7125,
                  0),
              child: Text(
                "Code Bois",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: MediaQuery.of(context).size.width / 7,
                    color: Colors.black),
              ),
            ),
            // ignore: deprecated_member_use
            TypewriterAnimatedTextKit(
              onTap: () {
                // print("Tap Event");
              },
              text: [
                'loading',
              ],
              textStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 15,
                  color: Colors.grey),
            ),
            // CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
