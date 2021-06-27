import 'package:flutter/material.dart';

//pages
import './signup.dart';
import './signin.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool isLogin = true;

  void toggle() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Bois Hackathon'),
      ),
      resizeToAvoidBottomInset: false,
      body: isLogin
          ? SignInPage(toggleSignin: toggle)
          : SignUpPage(toggleSignin: toggle),
    );
  }
}
