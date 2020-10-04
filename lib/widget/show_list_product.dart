import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_shoping_mall/models/product_model.dart';

class ShowListProduct extends StatefulWidget {
  ShowListProduct({Key key}) : super(key: key);

  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  List<ProductModel> productModels = List();

  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<Null> readAllData() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Product');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        // print('snapshot = $snapshot');
        print('Name = ${snapshot.data['Name']}');
        ProductModel productModel = ProductModel.fromMap(snapshot.data);
        setState(() {
          productModels.add(productModel);
        });
      }
    });
  }

  Widget showImage(int index) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
                image: NetworkImage(productModels[index].pathImage),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget showText(int index) {
    return Container(padding: EdgeInsets.only(right: 30.0,),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          showName(index),
          showDetail(index),
        ],
      ),
    );
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          productModels[index].name,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
          ),
        ),
      ],
    );
  }

  Widget showDetail(int index) {
    String string = productModels[index].detail;
    if (string.length > 100) {
      string = string.substring(0, 99);
      string = '$string...';
    }
    return Text(
      string,
      style: TextStyle(
        fontSize: 14.0,
        fontStyle: FontStyle.italic,color: Colors.deepPurple
      ),
    );
  }

  Widget showListView(int index) {
    return Row(
      children: [
        showImage(index),
        showText(index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext buildContext, int index) {
          return showListView(index);
        },
        itemCount: productModels.length,
      ),
    );
  }
}
