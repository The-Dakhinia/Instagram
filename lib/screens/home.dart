import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          width: 105.w,
          height: 28.h,
          child: Image.asset('images/logo.jpg'),
        ),
        leading: Icon(
          Icons.camera_alt_outlined,
          color: Colors.black,
        ),
        actions: [
          Icon(
            Icons.favorite_border_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 10.w,
          ),
          Image.asset(
            'images/send.png',
            height: 20.h,
            width: 20.h,
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
              stream: _firebaseFirestore
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        color: Colors.black,
                      );
                    }
                    return PostWidget(snapshot.data!.docs[index].data());
                  }, childCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  ),
                );
              })
        ],
      ),
    );
  }
}
