import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:instagram/auth/auth_screen.dart";
import "package:instagram/widgets/navigation.dart";

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const Navigation_Screen();
          }else{
            return const Authpage();
          }
        }
      )
    );
  }
}
