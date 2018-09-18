import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wfp_assignment/Note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(new MaterialApp(
  title: 'New Note',
  home: new NotesPage(),
));

class NotesPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _NotesPageState();
}



class _NotesPageState extends State<NotesPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Note _data = new Note("","");

/* save entries to fie=restore and return to home screen*/

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      print('message: ${_data.text}');
      print('name: ${_data.name}');

      Firestore.instance.runTransaction((transaction) async{

        Firestore.instance
            .collection("notes")
            .document()
            .setData({
          "message": "${_data.text}",
          "creator": "${_data.name}",

        });



        Navigator.pop(context);


      });


    }



  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('New Note'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: 'a message',
                        labelText: 'Enter a Message'
                    ),
                    onSaved: (String value) {
                      this._data.text = value;
                    }
                ),
                new TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: new InputDecoration(
                        hintText: 'Jane Doe',
                        labelText: 'Enter your Name'
                    ),
                    onSaved: (String value) {
                      this._data.name = value;
                    }
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Submit',
                      style: new TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: this.submit,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(
                      top: 20.0
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}