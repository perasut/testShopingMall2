import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_shoping_mall/screeens/authen.dart';
import 'package:test_shoping_mall/screeens/my_service.dart';
import 'package:test_shoping_mall/screeens/register.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (context) => MyService(),
      );
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    }
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'shop 9mall',
      style: TextStyle(
        fontSize: 30.0,
        color: Colors.blue[900],
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontFamily: 'Pacifico',
      ),
    );
  }

  Widget signInButton() {
    return RaisedButton(
      color: Colors.indigo.shade700,
      child: Text(
        'Sign IN',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (context) => Authen(),);
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget signUpButton() {
    return OutlineButton(
      child: Text('Sign Up'),
      onPressed: () {
        print('you click sign up button');
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (context) => Register(),
        );
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        signInButton(),
        SizedBox(
          width: 4.0,
        ),
        signUpButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
                colors: [Colors.white, Colors.blue.shade600], radius: 1.0),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showLogo(),
                showAppName(),
                SizedBox(
                  height: 8.0,
                ),
                showButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
