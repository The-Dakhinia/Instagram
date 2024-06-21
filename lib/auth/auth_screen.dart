import 'package:flutter/material.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool a = true;
  void go()
  {
    setState(() {
      a = !a;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(a)
      {
        return LoginScreen(go);
      }
    else
      {
        return SignUpScreen(go);
      }
  }
}
