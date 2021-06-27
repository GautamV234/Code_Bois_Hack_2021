import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//utils
import '../utils/authentication_service.dart';

class SignInPage extends StatefulWidget {
  final Function() toggleSignin;
  const SignInPage({Key? key, required this.toggleSignin}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
          child: Column(
            children: <Widget>[
              // Text(
              //   'Sign in with Username & Password',
              //   style: TextStyle(
              //     color: Colors.blue,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 20,
              //     fontFamily: 'Montserrat',
              //   ),
              // ),
              SizedBox(height: 10.0),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        fontFamily: 'Montserrat',
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green))),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String? message = await AuthenticationService().signIn(
                    username: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  print(message);
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          alignment: Alignment.center,
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () async {
              // showDialog(
              //   context: context,
              //   barrierDismissible: false,
              //   builder: (context) => Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // );
              String? message = await AuthenticationService().signInWithGoogle();
              print(message);
              //Navigator.of(context).pop();
            },
            child: Wrap(
              children: <Widget>[
                Icon(FontAwesomeIcons.google),
                SizedBox(width: 10),
                Text('Sign-in using Google',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    )
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'New to the app?',
              style: TextStyle(
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(width: 5.0),
            InkWell(
              onTap: () {
                widget.toggleSignin();
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                    color: Colors.green,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ]
    );
  }
}
