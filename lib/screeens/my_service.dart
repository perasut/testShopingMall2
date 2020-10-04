import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_shoping_mall/screeens/home.dart';
import 'package:test_shoping_mall/widget/add_list_product.dart';
import 'package:test_shoping_mall/widget/show_list_product.dart';

class MyService extends StatefulWidget {
  MyService({Key key}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  String login = '....';
  Widget currentWidget = ShowListProduct();

  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Widget showListProduct() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36.0,
        color: Colors.purple,
      ),
      title: Text('List Product'),
      subtitle: Text('Show all List Product'),
      onTap: () {
        setState(() {
          currentWidget = ShowListProduct();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget showAddList() {
    return ListTile(
      leading: Icon(
        Icons.playlist_add,
        color: Colors.orange,
        size: 40.0,
      ),
      title: Text('Add List Product'),
      subtitle: Text('Add new Product to database'),
      onTap: () {
        setState(() {
          currentWidget = AddListProduct();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Future<Null> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      login = firebaseUser.displayName;
    });
    print('login = $login');
  }

  Widget showLogin() {
    return Text(
      'Login By $login',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget showAppName() {
    return Text(
      'TestShoppingMall',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pacifico',
        fontStyle: FontStyle.italic,
        fontSize: 18.0,
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showHead() {
    return DrawerHeader(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('images/shopping.jpg'),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            showLogo(),
            showAppName(),
            SizedBox(height: 6.0),
            showLogin(),
          ],
        ));
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: [
          showHead(),
          showListProduct(),
          showAddList(),
        ],
      ),
    );
  }

  Widget signOutButton() {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        tooltip: 'sign out',
        onPressed: () {
          myalert();
        });
  }

  void myalert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want sign out?'),
          actions: [cancelButton(), okButton()],
        );
      },
    );
  }

  Widget cancelButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('cancel'));
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
          processSignout();
        },
        child: Text('ok'));
  }

  Future<void> processSignout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (context) => Home(),
      );
      Navigator.of(context)
          .pushAndRemoveUntil(materialPageRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My service app'),
        actions: [signOutButton()],
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
