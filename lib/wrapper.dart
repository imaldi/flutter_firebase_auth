import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/login_register.dart';
import 'package:flutter_firebase_auth/model/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    print(user);

    // return either the Home or Authenticate widget
    return LoginSignUpPage();
  }
}
