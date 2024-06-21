import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/screens/add_post_screen.dart';
import 'package:instagram/screens/add_reels_screen.dart';

class AddScreeen extends StatefulWidget {
  const AddScreeen({super.key});

  @override
  State<AddScreeen> createState() => _AddScreeenState();
}


class _AddScreeenState extends State<AddScreeen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  void navigationTapped(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          PageView(
            physics: ClampingScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageChanged,
            children: const [AddPostScreen(), AddReelsScreen()],
          ),
          AnimatedPositioned(
            bottom: 10.h,
            right: _currentIndex == 0 ? 100.w : 150.w,
            duration: Duration(milliseconds: 300),
            child: Container(
              width: 120.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      navigationTapped(0);
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: _currentIndex == 0 ? Colors.white : Colors.grey
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      navigationTapped(1);
                    },
                    child: Text(
                      'Reels',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: _currentIndex == 0 ? Colors.grey : Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
