import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<dynamic> fetchPeople(http.Client client) async {
  final response =
  await client.get('https://swapi.co/api/people/?format=json');

  var data = await json.decode(response.body);
  return data;
  // Use the compute function to run parsePhotos in a separate isolate.
  //return compute(parsePhotos, response.body);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<dynamic>(
        future: fetchPeople(http.Client()),
         builder: (context, snapshot){
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ?PeopleList (people: snapshot.data)
              : Center(child: CircularProgressIndicator());
         }
    )
    );

  }
}

class PeopleList extends StatelessWidget {
  //final List<dynamic> photos;
 final dynamic people;
  PeopleList({Key key, this.people}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var results = people ['results'];
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var person = results[index];
        var name = person ['name'];
        var birthYear = person ['birth_year'];
        return ListTile(
          title: Text (name),
          subtitle: Text(birthYear),

        );  //return Image.network(results[index].thumbnailUrl);
      },
    );
  }
}