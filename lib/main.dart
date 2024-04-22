import 'package:flutter/material.dart';
import 'package:testapp/alldonescreen.dart';
import 'package:testapp/forgotpasswordscreen.dart';
import 'package:testapp/loginscreen.dart';
import 'package:testapp/setnewpassword.dart';
import 'package:testapp/signupscreen.dart';
import 'package:testapp/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SignUpScreen(), // SignUpScreen firs  
        '/forgotpassword': (context) => ForgotPasswordScreen(),
        '/setnewpassword': (context) => SetNewPassword(),
        '/alldonescreen': (context) => AllDoneScreen(),
        '/loginscreen' :(context) => LoginScreen(),
        '/dashboard' :(context) => Dashboard(),

      },
    );
  }
}

