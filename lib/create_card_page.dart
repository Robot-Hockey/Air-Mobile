import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'home_page.dart';
import 'dart:convert';
import 'package:toast/toast.dart';

class CreateCardPage extends StatefulWidget {
  static String tag = 'create-card-page';
  @override
  _CreateCardPageState createState() => new _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  
  final storage = new FlutterSecureStorage();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Future<Null> _submitDialog(BuildContext context) async {
    return await showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
    });
  }

  @override
  Widget build(BuildContext context) {

    final cardTitle = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Create Card',
        style: TextStyle(fontSize: 28.0, color: Colors.black),
      ),
    );

    final nameField = TextField(
      autofocus: false,
      controller: _nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Name'
      )
    );

    final emailField = TextField(
      autofocus: false,
      controller: _emailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email'
      ),
    );

    createClient() async {
      String name = _nameController.text;
      String email = _emailController.text;
      String authToken = await storage.read(key: 'authToken');
      String companyId = await storage.read(key: 'companyId');
      debugPrint('company ID: ' + companyId.toString());
      String cardId = await storage.read(key: 'cardId');
      debugPrint('card ID: ' + cardId.toString());
      String url = 'https://rockey-api.lappis.rocks/cards';
      Map<String, String> headers = {"Content-type": "application/json",
                                     HttpHeaders.authorizationHeader: authToken};

      Map jsonMap = {
        'card': {
          'name': name,
          'email': email,
          'company_id': companyId,
          'public_id': cardId
        }
      };

      _submitDialog(context);

      Response response = await post(url, headers: headers, body: json.encode(jsonMap));
      int statusCode = response.statusCode;
      debugPrint(statusCode.toString());
      Navigator.pop(context);
      if(statusCode == 201) {
        Navigator.of(context).pushNamed(HomePage.tag);
      }else {
        Toast.show("Could not create card", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    }

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 12.0),
                cardTitle,
                SizedBox(height: 15.0),
                nameField,
                SizedBox(height: 15.0),
                emailField,
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Cancel'),
                        onPressed: () { 
                          Navigator.of(context).pushReplacementNamed(HomePage.tag);
                        },
                      ),
                      RaisedButton(
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          createClient();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: body
    );
  }
}
