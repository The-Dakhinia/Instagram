import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/firestore.dart';
import 'package:instagram/data/model/usermodel.dart';
import 'package:instagram/screens/post_screen.dart';
import 'package:instagram/util/image_cached.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;

  ProfileScreen({super.key, required this.Uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int post_length = 0;
  bool yours = false;
  List followings = [];
  bool isfollow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    if (_auth.currentUser!.uid == widget.Uid) {
      setState(() {
        yours = true;
      });
    }
  }

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    List follow = (snap.data()! as dynamic)['following'];
    if (follow.contains(widget.Uid)) {
      setState(() {
        isfollow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: Firebase_Firestore().getUser(uidd: widget.Uid),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      }
                      return Head(snapshot.data!);
                    },
                  ),
                ),
                StreamBuilder(
                  stream: _firebaseFirestore
                      .collection('posts')
                      .where('uid', isEqualTo: _auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      );
                    }
                    post_length = snapshot.data!.docs.length;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var snap = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PostScreen(snap.data())));
                          },
                          child: Container(
                            child: CachedImage(snap['postImage']),
                          ),
                        );
                      }, childCount: post_length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4),
                    );
                  },
                )
              ],
            ),
          )),
    );
  }

  Widget Head(UserModel user) {
    return Container(
      padding: EdgeInsets.only(bottom: 5.h, top: 10.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: CachedImage(user.profile),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 35.w,
                      ),
                      Text(
                        post_length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 60.w,
                      ),
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                      SizedBox(
                        width: 67.w,
                      ),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 25.w,
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        'Following',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  user.bio,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          if (!isfollow)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: InkWell(
                onTap: () {
                  if (!yours) {
                    Firebase_Firestore().follow(uid: widget.Uid);
                    setState(() {
                      isfollow = true;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: yours ? Colors.white : Colors.blue,
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                          color: yours ? Colors.grey.shade400 : Colors.blue)),
                  child: yours
                      ? Text(
                          'Edit Your Profile',
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        )
                      : Text(
                          'Follow',
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                ),
              ),
            ),
          if (isfollow)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Firebase_Firestore().follow(uid: widget.Uid);
                        setState(() {
                          isfollow = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30.h,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: Colors.grey.shade200)),
                        child: Text(
                          'Unfollow',
                          style:
                              TextStyle(color: Colors.black, fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.grey.shade200)),
                      child: Text(
                        'Message',
                        style:
                            TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  )
                ],
              ),
            ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Icon(Icons.grid_on),
                Icon(Icons.video_collection),
                Icon(Icons.person)
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
