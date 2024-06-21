import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/widgets/comment.dart';

import '../util/image_cached.dart';
import 'like_animation.dart';

class PostWidget extends StatefulWidget {
  final snapshot;

  PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
  }

  int countLike() {
    return widget.snapshot['like'].length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                  width: 35.w,
                  height: 35.h,
                  child: CachedImage(widget.snapshot['profileImage']),
                ),
              ),
              title: Text(
                widget.snapshot['username'],
                style: TextStyle(fontSize: 13.sp),
              ),
              subtitle: Text(
                widget.snapshot['location'],
                style: TextStyle(fontSize: 11.sp),
              ),
              trailing: const Icon(Icons.more_horiz),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestore().like(
              like: widget.snapshot['like'],
              type: 'posts',
              uid: user,
              postId: widget.snapshot['postId'],
            );
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 375.w,
                height: 375.h,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                    child: Icon(
                      Icons.favorite,
                      size: 100.w,
                      color: Colors.red,
                    ),
                    isAnimating: isAnimating,
                    duration: Duration(milliseconds: 400),
                    iconlike: false,
                    end: () {
                      setState(() {
                        isAnimating = false;
                      });
                    }),
              )
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                width: 14.h,
              ),
              Row(
                children: [
                  LikeAnimation(
                    child: IconButton(
                      onPressed: () {
                        Firebase_Firestore().like(
                          like: widget.snapshot['like'],
                          type: 'posts',
                          uid: user,
                          postId: widget.snapshot['postId'],
                        );
                      },
                      icon: Icon(
                        widget.snapshot['like'].contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.snapshot['like'].contains(user)
                            ? Colors.red
                            : Colors.black,
                        size: 24.w,
                      ),
                    ),
                    isAnimating: widget.snapshot['like'].contains(user),
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      showBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: DraggableScrollableSheet(
                                  maxChildSize: 0.6,
                                  initialChildSize: 0.6,
                                  minChildSize: 0.2,
                                  builder: (context, scrollController) {
                                    return Comment(
                                        widget.snapshot['postId'], 'posts');
                                  }),
                            );
                          });
                    },
                    child: Image.asset(
                      'images/comment.png',
                      height: 20.h,
                    ),
                  ),
                  SizedBox(
                    width: 17.w,
                  ),
                  Image.asset(
                    'images/send.png',
                    height: 21.h,
                  ),
                  Spacer(),
                  Image.asset(
                    'images/save.png',
                    height: 28.h,
                  ),
                ],
              ),
              // Modified Padding Section
              Padding(
                padding: EdgeInsets.only(
                  left: 19.w,
                  bottom: 5.h,
                ),
                child: Row(
                  children: [
                    Text(
                      countLike().toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['username'] + ' ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.snapshot['caption'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 8.h),
                child: Row(
                  children: [
                    Text(
                      formatDate(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.snapshot['time'].seconds * 1000),
                          [dd, '-', mm, '-', yyyy]),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
