import 'package:air_app/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final storage = new FlutterSecureStorage();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  loginUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String url = 'https://rockey-api.lappis.rocks/login';
    Map<String, String> headers = {"Content-type": "application/json"};

    Map jsonMap = {
      'email': email,
      'password': password
    };

    _submitDialog(context);

    Response response = await post(url, headers: headers, body: json.encode(jsonMap));
    int statusCode = response.statusCode;
    debugPrint(statusCode.toString());

    String body = response.body;
    Map<String, dynamic> jsonResponse = jsonDecode(body);
    Navigator.pop(context);
    if(statusCode == 200) {
      String authToken = jsonResponse['auth_token'];
      int companyId = jsonResponse['user']['company_id'];
      debugPrint(authToken);
      await storage.write(key: 'authToken', value: authToken);
      await storage.write(key: 'companyId', value: companyId.toString());
      Navigator.of(context).pushNamed(HomePage.tag);
    }else {
      Toast.show("Wrong credentials", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

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
    // final logo = Hero(
    //   tag: 'hero',
    //   child: CircleAvatar(
    //     backgroundColor: Colors.transparent,
    //     radius: 48.0,
    //     // child: Image.asset('assets/logo.png'),
    //   ),
    // );

    final emailField = TextField(
      autofocus: false,
      controller: _emailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email'
      ),
    );

    final passwordField = TextField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password'
      ),
    );

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
                const ListTile(
                  title: Text('Login'),
                  subtitle: Text('Fill with your credentials'),
                ),
                SizedBox(height: 12.0),
                emailField,
                SizedBox(height: 14.0),
                passwordField,
                SizedBox(height: 16.0),
                ButtonTheme.bar(
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Forgot password?'),
                        onPressed: () { /* ... */ },
                      ),
                      RaisedButton(
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          loginUser();
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