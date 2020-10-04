import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_shoping_mall/screeens/my_service.dart';

class Authen extends StatefulWidget {
  Authen({Key key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();
  String emailString, passwordString;

  Widget backButton() {
    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        size: 36.0,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget content() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showAppName(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }

  Widget showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [showLogo(), showText()],
    );
  }

  Widget showLogo() {
    return Container(
      width: 48.0,
      height: 48.0,
      child: Image.asset(
        'images/logo.png',
      ),
    );
  }

  Widget showText() {
    return Text(
      'Test shopppingMall',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
        fontFamily: 'Pacifico',
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            size: 36.0,
            color: Colors.blue.shade700,
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
          ),
        ),
        onSaved: (String value) {
          emailString = value.trim();
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 250.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 36.0,
            color: Colors.blue.shade700,
          ),
          labelText: 'password',
          labelStyle: TextStyle(
            color: Colors.blue.shade700,
          ),
        ),
        onSaved: (String value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  Future<Null> checAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('auth sucess');
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (context) => MyService(),
      );
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      myAlert(title, message);
    });
  }

  Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.add_alert,
        size: 48.0,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void myAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: showTitle(title),
          content: Text(message),
          actions: [okButton()],
        );
      },
    );
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('ok'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            colors: [Colors.white, Colors.blue.shade600],
            radius: 1.0,
          )),
          child: Stack(
            children: [
              backButton(),
              content(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          formKey.currentState.save();
          print('email= $emailString,password =$passwordString');
          checAuthen();
        },
        child: Icon(
          Icons.navigate_next,
          size: 36.0,
        ),
      ),
    );
  }
}
