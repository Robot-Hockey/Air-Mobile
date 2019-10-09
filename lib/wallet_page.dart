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
        'Add Credit',
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

    final valueField = TextField(
      autofocus: false,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true
      ),
      controller: _valueController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter de value'
      ),
    );

    addCredit() async {
      String authToken = await storage.read(key: 'authToken');
      String value = _valueController.text;
      String cardId = await storage.read(key: 'cardId');
      debugPrint('card ID: ' + cardId.toString());
      String url = 'https://hockey-api.lappis.rocks/operations';
      Map<String, String> headers = {"Content-type": "application/json",
                                     HttpHeaders.authorizationHeader: authToken};

      Map jsonMap = {
        'operation': {
          'value': int.parse(value),
          'public_id': cardId
        }
      };

      _submitDialog(context);

      Response response = await post(url, headers: headers, body: json.encode(jsonMap));
      int statusCode = response.statusCode;
      debugPrint(statusCode.toString());
      Navigator.pop(context);
      if(statusCode == 201) {
        Toast.show("Credit added successfully!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        Navigator.of(context).pushNamed(HomePage.tag);
      }else {
        Toast.show("Could not add value to card", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
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
                valueField,
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
                          addCredit();
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
      body: body,
    );
  }
}
