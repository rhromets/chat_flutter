import 'package:chat_flutter/components/rounded_button.dart';
import 'package:chat_flutter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool isShowMessage = false;

  @override
  void initState() {
    isShowMessage = false;
    super.initState();
  }

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
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
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
                height: 24.0,
              ),
              Builder(builder: (BuildContext context) {
                return RoundedButton(
                  color: Colors.lightBlueAccent,
                  buttonTitle: 'Log In',
                  onPressed: () async {
                    setState(() {
                      isShowMessage = false;
                    });
                    final progress = ProgressHUD.of(context);
                    progress?.show();
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
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
                  },
                );
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
