import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase_auth/service/authentication.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userId;
  HomePage({Key key, this.auth, this.userId, this.onSignOut}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    // _checkEmailVerification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Apps'),
        backgroundColor: Colors.green,
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showDialogKonfirmasiEmail();
      //   }, tooltip: 'Confirm',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // void _checkEmailVerification() async {
  //   isEmailVerified = await widget.auth.isEmailVerified();
  //   if (!isEmailVerified) {
  //     _showDialogKonfirmasiEmail();
  //   }
  // }

  void _showDialogKonfirmasiEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verify your account'),
          content: Text('Please verify account in the link sent to your email'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Dismiss'),
            )
          ],
        );
      },
    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }
}
