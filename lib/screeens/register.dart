import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_shoping_mall/screeens/my_service.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString;

  Widget registerButton() {
    return IconButton(
        icon: Icon(Icons.cloud_upload),
        onPressed: () {
          print('you click upload');
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            print(
                'name = $nameString,email = $emailString,password = $passwordString');
            registerThread();
          }
        });
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('register sucess = $emailString');
      setupDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title,message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response) {
      
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nameString;
      response.updateProfile(userUpdateInfo);

      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (context) => MyService(),
      );
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: ListTile(
            leading: Icon(
              Icons.add_alert,
              color: Colors.red,
            ),
            title: Text(
              title,
              style: TextStyle(color: Colors.red),
            ),
          ),
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }

  Widget nameText() {
    return TextFormField(
      style: TextStyle(
        color: Colors.purple,
      ),
      decoration: InputDecoration(
          icon: Icon(
            Icons.face,
            color: Colors.purple,
            size: 48.0,
          ),
          labelText: 'Display Name :',
          labelStyle: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type your name for Display',
          helperStyle: TextStyle(
            color: Colors.purple,
            fontStyle: FontStyle.italic,
          )),
      validator: (String value) {
        if (value.isEmpty) {
          return 'please Fill your Name in the Blank';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.orange.shade700,
      ),
      decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Colors.orange.shade700,
            size: 48.0,
          ),
          labelText: 'Email :',
          labelStyle: TextStyle(
            color: Colors.orange.shade700,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type your email',
          helperStyle: TextStyle(
            color: Colors.orange.shade700,
            fontStyle: FontStyle.italic,
          )),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'please Type your Email exp.uou@email.com';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      style: TextStyle(
        color: Colors.green.shade800,
      ),
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.green.shade800,
            size: 48.0,
          ),
          labelText: 'Password :',
          labelStyle: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
          helperText: 'Type your password',
          helperStyle: TextStyle(
            color: Colors.green.shade800,
            fontStyle: FontStyle.italic,
          )),
      validator: (String value) {
        if (value.length < 6) {
          return 'password more than 6 charactor';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value.trim();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: Text('Register'),
        actions: [registerButton()],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: [
            nameText(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }
}
