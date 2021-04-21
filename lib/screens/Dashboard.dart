import 'package:fast_order/screens/Order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_order/screens/Login.dart';
import 'package:fast_order/models/Meja.dart';
import 'package:fast_order/service/MejaService.dart';
import 'package:fast_order/screens/PesananTab.dart';
import 'package:fast_order/screens/Akun.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences sharedPreferences;
  MejaApiService apiService;
  int _selectedNavbar = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    apiService = MejaApiService();
  }

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // jika user belum login
    if (sharedPreferences.getString("username") == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => Login()),
                  (Route<dynamic> route) => false);
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: (_selectedNavbar == 0)
          ? _beranda()
          : (_selectedNavbar == 1) ? PesananTab() : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Beranda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Pesanan'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   title: Text('Akun'),
          // ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _changeSelectedNavBar,
      ),
    );
  }

  Widget _beranda() {
    return Container(
      margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
      child: Column(
        children: [
          Text(
            "Selamat Datang",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Text(
            "Silahkan pilih meja terlebih dahulu untuk memulai pesanan Anda",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 03.0),
          ),
          Divider(
            color: Colors.black,
          ),
          Expanded(
            child: FutureBuilder(
              future: apiService.getMeja(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Meja>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something wrong with message: ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<Meja> tables = snapshot.data;
                  return Container(
                    margin: EdgeInsets.only(left: 50.0, right: 50.0),
                    child: _listBuildView(tables),
                  );
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listBuildView(List<Meja> tables) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int i) =>
          Divider(color: Colors.grey[400]),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        Meja meja = tables[index];
        return Ink(
          color: meja.statusMeja == "kosong" ? Colors.black : Colors.red,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Order(
                    noMeja: meja.noMeja,
                    statusMeja: meja.statusMeja,
                    idMeja: meja.id,
                  ),
                ),
              );
            },
            title: Text(
              "Nomor meja : " + meja.noMeja,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            hoverColor: Colors.blue,
          ),
        );
      },
    );
  }
}
