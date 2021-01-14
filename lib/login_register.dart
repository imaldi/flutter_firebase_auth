import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/service/authentication.dart';

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onLoggedIn});

  final BaseAuth auth;
  final VoidCallback onLoggedIn;
  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _errorMessage;

  //deklarasi form untuk login
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  //cek apakah form valid sebelum perform login atau signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //perform login atau register
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print("user sign id : $userId");
        } else {
          userId = await widget.auth.signUp(_email, _password).then((value) {
            _changeFormKeLogin();
            return value;
          });
          // widget.auth.sendEmailVerification();
          // _showDialogVerification();
          print("sign up id : $userId");
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onLoggedIn();
        }
      } catch (e) {
        print("Error : $e");
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else {
            _errorMessage = e.message;
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
  }

  void _changeFormKeSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormKeLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Apps'),
      ),
      body: Stack(
        children: [
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  // void _showDialogVerification() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Verify Your Account'),
  //           content: Text('Link to verify account has been sent to your email'),
  //           actions: [
  //             FlatButton(
  //                 onPressed: () {
  //                   _changeFormKeLogin();
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Dismiss'))
  //           ],
  //         );
  //       });
  // }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            _displayLogo(),
            _displayEmailInput(),
            _displayPassword(),
            _displayPrimaryButton(),
            _displaySecondaryButton(),
            _displayMessageError(),
          ],
        ),
      ),
    );
  }

  Widget _displayMessageError() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            height: 1.0,
            fontSize: 13.0),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _displayLogo() {
    return Hero(
      tag: 'logo udacoding',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child:
              Image.asset('image/udacoding.png'), //nanti masukkan gambar disini
        ),
      ),
    );
  }

  Widget _displayEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(
            Icons.email,
            color: Colors.green,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _displayPassword() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.green,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _displayPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 4.5, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.green,
          child: _formMode == FormMode.LOGIN
              ? Text('Login',
                  style: TextStyle(fontSize: 20.0, color: Colors.white))
              : Text('Create Account',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: () {
            _validateAndSubmit();
          },
        ),
      ),
    );
  }

  Widget _displaySecondaryButton() {
    return FlatButton(
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormKeSignUp
          : _changeFormKeLogin,
      child: _formMode == FormMode.LOGIN
          ? Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            )
          : Text(
              'Have an Account? Please sign in',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
