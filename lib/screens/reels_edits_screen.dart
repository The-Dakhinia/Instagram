import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/data/firebase_service/storage.dart';
import 'package:video_player/video_player.dart';

class ReelsEditScreen extends StatefulWidget {
  File videoFile;

  ReelsEditScreen(this.videoFile, {super.key});

  @override
  State<ReelsEditScreen> createState() => _ReelsEditScreenState();
}

class _ReelsEditScreenState extends State<ReelsEditScreen> {
  final caption = TextEditingController();
  late VideoPlayerController controller;
  bool Loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(1.0);
          controller.play();
        }
      );
      }
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        leading: Icon(Icons.arrow_back_ios, color: Colors.black,),
        title: Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Loading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.black,
              ))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Container(
                          width: 270.w,
                          height: 420.h,
                          child: controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: VideoPlayer(controller),
                                )
                              : CircularProgressIndicator(
                                  color: Colors.black,
                                )),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 60.h,
                      width: 280.w,
                      child: TextField(
                        controller: caption,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'Write a caption ...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 45.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Text(
                            'Save draft',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              Loading = true;
                            });
                            String Reels_Url = await StorageMethod()
                                .uploadImageToStorage(
                                    'Reels', widget.videoFile);
                            await Firebase_Firestore().CreateReels(
                                video: Reels_Url,
                                caption: caption.text
                            );
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 45.h,
                            width: 150.w,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
