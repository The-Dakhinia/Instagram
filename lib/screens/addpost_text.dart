import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/data/firebase_service/storage.dart';

class AddPostTextScreen extends StatefulWidget {
  File _file;

  AddPostTextScreen(this._file, {super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'New post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isloading = true;
                  });
                  String post_url = await StorageMethod()
                      .uploadImageToStorage('post', widget._file);
                  await Firebase_Firestore().CreatePost(
                      postImage: post_url,
                      caption: caption.text,
                      location: location.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Share',
                  style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: isloading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      child: Row(
                        children: [
                          Container(
                            width: 65.w,
                            height: 65.h,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: FileImage(widget._file),
                                    fit: BoxFit.cover)

                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 200.w,
                            height: 60.h,
                            child: TextField(
                              controller: caption,
                              decoration: InputDecoration(
                                hintText: 'Write a caption ...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SizedBox(
                        width: 200.w,
                        height: 30.h,
                        child: TextField(
                          controller: location,
                          decoration: InputDecoration(
                            hintText: 'Add location',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
