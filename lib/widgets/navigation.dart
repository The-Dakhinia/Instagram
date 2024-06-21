import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/screens/add_screen.dart';
import 'package:instagram/screens/eplore.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/profile_screen.dart';
import 'package:instagram/screens/reels_screen.dart';

class Navigation_Screen extends StatefulWidget {
  const Navigation_Screen({super.key});

  @override
  State<Navigation_Screen> createState() => _Navigation_ScreenState();
}

class _Navigation_ScreenState extends State<Navigation_Screen> {
  int _currentIndex = 0;
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Future<bool> onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
        pageController.jumpToPage(0);
      });
      return false; // Prevent the default back button behavior
    } else {
      return true; // Allow the app to close
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: navigationTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/instagram-reels-icon.png',
                height: 20.h,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeScreen(),
            ExploreScreen(),
            AddScreeen(),
            ReelScreen(),
            ProfileScreen(
              Uid: _auth.currentUser!.uid,
            )
          ],
        ),
      ),
    );
  }
}
