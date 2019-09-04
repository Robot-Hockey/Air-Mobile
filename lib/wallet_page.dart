import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  static String tag = 'wallet-page';
  String cardId = '';

  WalletPage({Key key, @required this.cardId}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final cardTitle = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Card',
        style: TextStyle(fontSize: 28.0, color: Colors.black),
      ),
    );

    final idField = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        cardId,
        style: TextStyle(fontSize: 16.0, color: Colors.black54),
      ),
    );

    final valueField = TextFormField(
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: true
      ),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter de value',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final addCreditButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: null,
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Adicionar Crédito', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      child: Column(
        children: <Widget>[cardTitle, idField, valueField, addCreditButton],
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
