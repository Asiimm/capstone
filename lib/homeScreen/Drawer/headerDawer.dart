import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  User? user;
  String? userName;

  @override
  void initState() {
    super.initState();
    _getUserEmail();
    _getUserName();
  }

  void _getUserEmail() {
    // Retrieve the current logged-in user
    user = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  void _getUserName() async {
    // Get the current user's UID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      // Query Firestore to get the user's name
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name']; // assuming 'name' field in Firestore
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2A1D46),
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profile.jpg'),
              ),
            ),
          ),
          // Display the user's name or a placeholder
          SizedBox(height: 90,),
          Text(
            userName ?? " ",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          // Display the current user's email, or a placeholder if the user is null
          Text(
            user?.email ?? "info@rapidtech.dev",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
