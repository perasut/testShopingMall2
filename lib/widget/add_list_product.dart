import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_shoping_mall/screeens/my_service.dart';

class AddListProduct extends StatefulWidget {
  AddListProduct({Key key}) : super(key: key);

  @override
  _AddListProductState createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  File file;
  String name, detail, urlPicture;

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: Colors.deepOrange,
            onPressed: () {
              print('you upload');
              if (file == null) {
                showAlert('Non choose picture', 'plese click camera');
              } else if (name == null ||
                  name.isEmpty ||
                  detail == null ||
                  detail.isEmpty) {
                showAlert('Have Space', 'Please fll blank');
              } else {
                uploadPictureToStorage();
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Text(
              'Upload Data to firebase',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('product/product$i.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('$urlPicture');
    inserValueToFirestore();
  }

  Future<Null> inserValueToFirestore() async {
    Firestore firestore = Firestore.instance;
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Detail'] = detail;
    map['PathImage'] = urlPicture;
    await firestore.collection('Product').document().setData(map).then((value) {
      print('inser success');
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => MyService(),
      );
      Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
    });
  }

  Future<Null> showAlert(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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

  Widget nameForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (String string) {
          name = string.trim();
        },
        decoration: InputDecoration(
          helperText: 'Type Your name of product',
          labelText: 'Name Product',
          icon: Icon(
            Icons.card_travel,
            size: 36.0,
            color: Colors.purple,
          ),
        ),
      ),
    );
  }

  Widget detailForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (String string) {
          detail = string.trim();
        },
        decoration: InputDecoration(
          helperText: 'Type Your name of detail',
          labelText: 'Detail Product',
          icon: Icon(
            Icons.details,
            size: 36.0,
            color: Colors.purple,
          ),
        ),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
        color: Colors.purple,
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
      },
    );
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
        color: Colors.green.shade700,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      // color: Colors.greenAccent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showImage(),
          showButton(),
          nameForm(),
          detailForm(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        showContent(),
        uploadButton(),
      ],
    );
  }
}
