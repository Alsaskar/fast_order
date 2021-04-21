import 'package:flutter/material.dart';
import 'package:fast_order/screens/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _fisrtname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _noHP = TextEditingController();
  bool _obsecureText = true;
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void signUp(String username, String password, String firstname,
      String lastname, String noHp) async {
    Map data = {
      'username': username,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'no_hp': noHp
    };
    var jsonData = null;

    var response = await http.post(
        "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/register",
        body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);

      if (jsonData['error'] == false) {
        setState(() {
          _isLoading = false;
          _username.clear();
          _password.clear();
          _fisrtname.clear();
          _lastname.clear();
          _noHP.clear();
        });
        _showContent('', jsonData['message']);
      } else if (jsonData['error'] == true) {
        setState(() {
          _isLoading = false;
          _username.clear();
          _password.clear();
          _fisrtname.clear();
          _lastname.clear();
          _noHP.clear();
        });
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
            : SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
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
                        padding: EdgeInsets.only(bottom: 05.0),
                        child: Text(
                          "Ikan Bakar Sahabat Nelayan",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                      Divider(color: Colors.white),
                      Text(
                        "Daftar Sekarang",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Form Register
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 15.0, right: 15.0),
                              child: TextFormField(
                                controller: _fisrtname,
                                decoration: InputDecoration(
                                  labelText: "Nama Depan",
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.only(
                                      left: 10.0, bottom: 7.0, top: 7.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Nama Depan tidak boleh kosong';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 15.0, right: 15.0),
                              child: TextFormField(
                                controller: _lastname,
                                decoration: InputDecoration(
                                  labelText: "Nama Belakang",
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.only(
                                      left: 10.0, bottom: 7.0, top: 7.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Nama Belakang tidak boleh kosong';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 15.0, right: 15.0),
                              child: TextFormField(
                                controller: _username,
                                decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.only(
                                      left: 10.0, bottom: 7.0, top: 7.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Username tidak boleh kosong';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 15.0, right: 15.0),
                              child: TextFormField(
                                controller: _password,
                                obscureText: _obsecureText,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obsecureText = !_obsecureText;
                                      });
                                    },
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.only(
                                      left: 10.0, bottom: 7.0, top: 7.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  left: 15.0,
                                  right: 15.0,
                                  bottom: 10.0),
                              child: TextFormField(
                                controller: _noHP,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Nomor Handphone",
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding: EdgeInsets.only(
                                      left: 10.0, bottom: 7.0, top: 7.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
                                    borderRadius: BorderRadius.circular(05.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'No HP tidak boleh kosong';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            ButtonTheme(
                              buttonColor: Colors.white,
                              minWidth: 200.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    signUp(
                                        _username.text,
                                        _password.text,
                                        _fisrtname.text,
                                        _lastname.text,
                                        _noHP.text);
                                  }
                                },
                                child: Text(
                                  "Daftar",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: InkWell(
                                child: Text(
                                  "Sudah daftar ? Masuk",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
