import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/home.dart';
import 'package:flutter_firebase_auth/login_register.dart';
import 'package:flutter_firebase_auth/model/user.dart';
import 'package:flutter_firebase_auth/service/authentication.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    // final user =
    // Provider.of<UserModel>(context);
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      _userId = "";
    });
  }

  void _onSignOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    if (user == null) {
      return LoginSignUpPage(
        auth: widget.auth,
        onLoggedIn: _onLoggedIn,
      );
    } else {
      return HomePage(
        userId: _userId,
        auth: widget.auth,
        onSignOut: _onSignOut,
      );
    }
    // switch (authStatus) {
    //   case AuthStatus.NOT_DETERMINED:
    //     return _buildWaitingScreen();
    //     break;
    //   case AuthStatus.NOT_LOGGED_IN:
    //     if (user == null) {
    //       return LoginSignUpPage(
    //         auth: widget.auth,
    //         onLoggedIn: _onLoggedIn,
    //       );
    //     } else
    //       return _buildWaitingScreen();
    //     break;
    //   case AuthStatus.LOGGED_IN:
    //     if (_userId.length > 0 && _userId != null) {
    //       return HomePage(
    //         userId: _userId,
    //         auth: widget.auth,
    //         onSignOut: _onSignOut,
    //       );
    //     } else
    //       return _buildWaitingScreen();
    //     break;
    //   default:
    //     return _buildWaitingScreen();
    // }
  }
}
