import 'package:air_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:air_app/wallet_page.dart';
import 'package:air_app/create_card_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {

    final logoutButton = Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Expanded(
          child: new Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                // padding: EdgeInsets.all(14.0),
                icon: new Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () => Navigator.of(context).pushReplacementNamed(LoginPage.tag)
              ),
          ),
        ),
      ]
    );

    final titleText = Padding(
      padding: EdgeInsets.all(2.0),
      child: Text(
        'Reader',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final nfcImage = Image.asset("assets/nfc.png");

    final subTitleText = Padding(
      padding: EdgeInsets.all(2.0),
      child: Text(
        'Present a card',
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[logoutButton, titleText, subTitleText, nfcImage],
          ),
      ),
    );

    checkCard(String cardId) async {
      await storage.write(key: 'cardId', value: cardId);
      String authToken = await storage.read(key: 'authToken');
      final response = await get(
        'https://hockey-api.lappis.rocks/cards/' + cardId,
        headers: {HttpHeaders.authorizationHeader: authToken},
      );
      int statusCode = response.statusCode;
      debugPrint(statusCode.toString());
      if(statusCode == 500) { // Card does not exist
        Navigator.of(context).pushNamed(CreateCardPage.tag);
      }else { 
        Navigator.of(context).pushNamed(WalletPage.tag);
      }
    }

    FlutterNfcReader.read().then((response) {
      checkCard(response.id);
    });

    return Scaffold(
      body: body,
    );
  }
}
