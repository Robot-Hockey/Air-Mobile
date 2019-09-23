import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'wallet_page.dart';
import 'create_card_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    WalletPage.tag: (context) => WalletPage(),
    CreateCardPage.tag: (context) => CreateCardPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Air Hockey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
