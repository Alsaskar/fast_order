import 'package:flutter/material.dart';
import 'package:fast_order/models/Pelanggan.dart';
import 'package:fast_order/service/PelangganService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Akun extends StatefulWidget {
  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  PelangganService apiService;
  Pelanggan pelanggan;
  SharedPreferences sharedPreferences;

  void initState() {
    apiService = PelangganService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pelanggan>(
      future: apiService.getPelanggan(),
      builder: (context, snapshot) {
        // jika connection none atau data = null
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          // tampung data dari server
          pelanggan = snapshot.data;

          if (pelanggan.id != 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundImage: AssetImage("assets/images/user.png"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Depan",
                        style: TextStyle(fontSize: 25.0),
                      ),
                      SizedBox(
                        width: 05.0,
                      ),
                      Text(
                        "Belakang",
                        style: TextStyle(fontSize: 25.0),
                      )
                    ],
                  ),
                  Text(
                    "Nomor HP",
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }
}
