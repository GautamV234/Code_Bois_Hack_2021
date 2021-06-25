import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//pages
import './authentication.dart';
import 'landing.dart';
import '../widgets/error_widget.dart';

//widgets
import '../widgets/loading_widget.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingWidget(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return CustomErrorWidget();
          } else if (snapshot.hasData) {
            return LandingPage();
          } else {
            return AuthenticationPage();
          }
        },
      ),
    );
  }
}
