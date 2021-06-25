import 'package:flutter/material.dart';

import '../utils/authentication_service.dart';

class SignUpPage extends StatefulWidget {
  final Function() toggleSignin;
  const SignUpPage({Key? key, required this.toggleSignin}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                TextFormField(
                  controller: usernameController,
                  validator: (input) {
                    if(input!.isEmpty){    
                      return 'Provide an username' ;           
                    } else{
                      bool usernamevalid = RegExp(r"^[a-zA-Z0-9]").hasMatch(input) && input.startsWith(RegExp(r"^[a-zA-Z]")); 
                      if(!usernamevalid){
                        return 'Provide a valid alphanumeric username';
                      }   
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.grey
                      ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                    )
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: passwordController,
                  // ignore: missing_return
                  validator: (input) {
                    if(input!.length < 6){
                      return 'Longer password please';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.grey
                      ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                    )
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {                   
                    final FormState form = _formKey.currentState!;
                    if (form.validate()) {
                      String? message =  await AuthenticationService().signUp( username: usernameController.text, password: passwordController.text);
                      print(message);
                    }
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account?',
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
                'Sign in',
                style: TextStyle(
                  color: Colors.green,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline
                ),
              ),
            ),
          ],
        ),
      ]
    );
  }
}