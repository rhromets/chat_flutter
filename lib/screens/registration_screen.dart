import 'package:flutter/material.dart';
import 'package:chat_flutter/components/rounded_button.dart';
import 'package:chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool isShowMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ProgressHUD(
        indicatorColor: Colors.lightBlueAccent,
        backgroundColor: Color(0x00000000),
        borderColor: Color(0x00000000),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 15.0,
              ),
              Builder(builder: (BuildContext context) {
                return RoundedButton(
                    color: Colors.blueAccent,
                    buttonTitle: 'Register',
                    onPressed: () async {
                      setState(() {
                        isShowMessage = false;
                      });
                      final progress = ProgressHUD.of(context);
                      progress?.show();
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          progress?.dismiss();
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                      } catch (e) {
                        Future.delayed(Duration(seconds: 5), () {
                          setState(() {
                            progress?.dismiss();
                            isShowMessage = true;
                          });
                        });
                        print(e);
                      }
                    });
              }),
              isShowMessage ? showMessage() : Text('')
            ],
          ),
        ),
      ),
    );
  }

  Text showMessage() {
    return Text(
      'Something wrong',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}
