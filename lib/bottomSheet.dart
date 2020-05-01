import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSheet extends StatefulWidget {
  @override
  _AddSheetState createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> {

  String movieName;
  String rating;
  final _fireStore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Add New Movie",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Movie Name",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(7.0),
                isDense: true,
              ),
              onChanged: (value){
                movieName=value;
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Rating",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(7.0),
                isDense: true,
              ),
              onChanged: (value){
                rating=value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.blueAccent,
              onPressed: ()async {
                _fireStore.collection("movies").add({
                  "Rating": rating,
                  "name": movieName,
                });
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
