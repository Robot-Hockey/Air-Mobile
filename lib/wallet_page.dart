import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'home_page.dart';

class WalletPage extends StatefulWidget {
  static String tag = 'wallet-page';
  @override
  _WalletPageState createState() => new _WalletPageState();
}


class _WalletPageState extends State<WalletPage> {

  final storage = new FlutterSecureStorage();
  final _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final cardTitle = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Add Credit to Card',
        style: TextStyle(fontSize: 28.0, color: Colors.black),
      ),
    );

    // final idField = Padding(
    //   padding: EdgeInsets.all(8.0),
    //   child: Text(
    //     cardId,
    //     style: TextStyle(fontSize: 16.0, color: Colors.black54),
    //   ),
    // );

    final valueField = TextFormField(
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true
      ),
      autofocus: false,
      controller: _valueController,
      decoration: InputDecoration(
        hintText: 'Enter de value',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    addCredit() async {
      String authToken = await storage.read(key: 'authToken');
      String value = _valueController.text;
      String cardId = await storage.read(key: 'cardId');
      debugPrint('card ID: ' + cardId.toString());
      String url = 'https://rockey-api.lappis.rocks/operations';
      Map<String, String> headers = {"Content-type": "application/json",
                                     HttpHeaders.authorizationHeader: authToken};

      Map jsonMap = {
        'operation': {
          'value': int.parse(value),
          'public_id': cardId
        }
      };

      Response response = await post(url, headers: headers, body: json.encode(jsonMap));
      int statusCode = response.statusCode;
      debugPrint(statusCode.toString());

      if(statusCode == 201) {
        Toast.show("Credit added successfully!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.of(context).pushNamed(HomePage.tag);
      }else {
        Toast.show("Could not add value to card", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    }

    final addCreditButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          addCredit();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Add Credit', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      child: Column(
        children: <Widget>[cardTitle, valueField, addCreditButton],
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
