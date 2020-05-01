import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottomSheet.dart';

void main() => runApp(MyApp());

const TextStyle title = TextStyle(
  color: Color(0xFF666666),
  fontWeight: FontWeight.bold,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Rating',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> options = ["Rating", "Name"];
  List<DropdownMenuItem> items = [];
  String selectedValue;
  IconData sortOrder = Icons.arrow_downward;
  final _fireStore = Firestore.instance;
  int order =0;

  void createItems() {
    for (var option in options)
      items.add(DropdownMenuItem(
        value: option,
        child: Text(
          option,
        ),
      ));
  }

  Stream<QuerySnapshot> getStreamOrder(){
    switch(selectedValue){
      case "Rating":
        switch(order){
          case 0:
            return _fireStore.collection("movies").orderBy("Rating",descending: true).snapshots();
          case 1:
            return _fireStore.collection("movies").orderBy("Rating",descending: false).snapshots();
        }
        break;
      case "Name":
        switch(order){
          case 0:
            return _fireStore.collection("movies").orderBy("name",descending: true).snapshots();
          case 1:
            return _fireStore.collection("movies").orderBy("name",descending: false).snapshots();
        }
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    createItems();
    selectedValue = options.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Movie Ratings 🎥",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddSheet(
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Sort By :",
                ),
                DropdownButton(
                  items: items,
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    child: Icon(
                      sortOrder,
                    ),
                    onTap: () {
                      setState(() {
                        if (sortOrder == Icons.arrow_upward)
                          {
                            sortOrder = Icons.arrow_downward;
                            order=0;
                          }
                        else
                          {
                            sortOrder = Icons.arrow_upward;
                            order=1;
                          }
                      });
                    }),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "TITLE",
                      style: title,
                    ),
                    flex: 10,
                  ),
                  Expanded(
                    child: Text(
                      "RATING",
                      style: title,
                    ),
                    flex: 2,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: getStreamOrder(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          List movies = snapshot.data.documents.toList();
                          return Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      movies[index]["name"],
                                    ),
                                    flex: 5,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                        movies[index]["Rating"].toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
