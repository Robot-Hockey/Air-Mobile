import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:air_app/wallet_page.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {

    final titleText = Padding(
      padding: EdgeInsets.all(2.0),
      child: Text(
        'Leitor',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final nfcImage = Image.asset("assets/nfc.png");

    final subTitleText = Padding(
      padding: EdgeInsets.all(2.0),
      child: Text(
        'Apresente um cartão',
        style: TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
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
          children: <Widget>[titleText, subTitleText, nfcImage],
          ),
      ),
    );

    FlutterNfcReader.read().then((response) {
      // Navigator.of(context).pushNamed(WalletPage.tag);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WalletPage(cardId: response.id),
          ),
        );
      print(response.id);
    });

    return Scaffold(
      body: body,
    );
  }
}
