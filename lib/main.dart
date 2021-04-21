import 'package:fast_order/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_order/screens/Dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var username = sharedPreferences.getString("username");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: username == "" ? Login() : Dashboard(),
  ));
}
