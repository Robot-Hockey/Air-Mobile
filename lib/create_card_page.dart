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

  @override
  Widget build(BuildContext context) {

    final cardTitle = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Create Card',
        style: TextStyle(fontSize: 28.0, color: Colors.black),
      ),
    );

    final nameField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _nameController,
      decoration: InputDecoration(
        hintText: 'Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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

      Response response = await post(url, headers: headers, body: json.encode(jsonMap));
      int statusCode = response.statusCode;
      debugPrint(statusCode.toString());

      if(statusCode == 201) {
        Navigator.of(context).pushNamed(HomePage.tag);
      }else {
        Toast.show("Could not create card", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    }

    final createCardButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          createClient();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Create Card', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      child: Column(
        children: <Widget>[SizedBox(height: 24.0),
                           cardTitle,
                           SizedBox(height: 15.0),
                           nameField,
                           SizedBox(height: 15.0),
                           emailField,
                           createCardButton],
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
