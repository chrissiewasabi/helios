import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wfp_assignment/addNote.dart';


void main() => runApp(new MyApp());
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Notes',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Notes '),
    );
  }


}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
     //stream builder will emit a new value when data changes
     body: new StreamBuilder(
          stream: Firestore.instance.collection('notes').snapshots,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('getting data...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent: 55.0,

                itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed:(){
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new NotesPage()),
          );        }
        ,
        tooltip: 'Add Note',
        child: new Icon(Icons.note_add),
      ),
    );


  }




  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new ListTile(
      key: new ValueKey(document.documentID),
      title: new Container(
        decoration: new BoxDecoration(
          border: new Border.all(color: const Color(0x80000000)),
          borderRadius: new BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(document['message']),
            ),
            new Text(
              document['creator'].toString(),
            ),
          ],
        ),
      ),

    );
  }
}



