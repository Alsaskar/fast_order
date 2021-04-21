import 'package:fast_order/screens/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fast_order/screens/Register.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  void signIn(String username, String password) async {
    Map data = {'username': username, 'password': password};
    var jsonData = null;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.post(
        "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/login",
        body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      if (jsonData['error'] == false) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString('username', jsonData['username']);
        sharedPreferences.setString('id_users', jsonData['id_users']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()),
            (Route<dynamic> route) => false);
      } else if (jsonData['error'] == true) {
        setState(() {
          _isLoading = false;
          _password.clear();
        });
        _showContent('Opppsss...', jsonData['message']);
      }
    }
  }

  void _showContent(String title, String msg) {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text(msg),
              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Rumah Makan",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "Ikan Bakar Sahabat Nelayan",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _username,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(color: Colors.white),
                          contentPadding: const EdgeInsets.only(
                              left: 10.0, bottom: 7.0, top: 7.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(05.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(05.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.white),
                          contentPadding: const EdgeInsets.only(
                              left: 10.0, bottom: 7.0, top: 7.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(05.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(05.0),
                          ),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      buttonColor: Colors.white,
                      minWidth: 200.0,
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          signIn(_username.text, _password.text);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: InkWell(
                        child: Text(
                          "Belum punya akun ? Daftar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
