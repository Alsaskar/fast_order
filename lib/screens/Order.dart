import 'package:fast_order/models/JenisMenu.dart';
import 'package:fast_order/screens/DetailOrder.dart';
import 'package:fast_order/service/JenisMenuService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  String noMeja, statusMeja;
  int idMeja;

  Order({@required this.noMeja, this.statusMeja, this.idMeja, Key key})
      : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  JenisMenuApiService apiService;

  @override
  void initState() {
    apiService = JenisMenuApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Jenis Menu "),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: orderMenu(),
      ),
    );
  }

  // widget untuk
  Widget orderMenu() {
    if (widget.statusMeja == "kosong") {
      // jika meja masih kosong
      return Column(
        children: [
          Text(
            "Silahkan untuk memesan pesanan di nomor meja : " + widget.noMeja,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Divider(
            color: Colors.black,
          ),
          Expanded(
            child: FutureBuilder(
              future: apiService.getJenisMenu(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<JenisMenu>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something wrong with message: ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<JenisMenu> tables = snapshot.data;
                  return Container(
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
      );
    } else if (widget.statusMeja == "terisi") {
      // jika meja terisi
      return Column(
        children: [
          Image.asset(
            "assets/images/table.jpg",
            width: 200.0,
            height: 180.0,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Maaf, meja ini telah terisi. Silahkan untuk kembali memilih meja yang lain",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.all(05.0),
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Pilih Meja Lain",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
            ),
          )),
        ],
      );
    }
  }

  Widget _listBuildView(List<JenisMenu> tables) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int i) =>
          Divider(color: Colors.grey[400]),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        JenisMenu jenisMenu = tables[index];
        return Ink(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailOrder(
                    noMeja: widget.noMeja,
                    namaJenis: jenisMenu.jenisMenu,
                    idMeja: widget.idMeja,
                    idJenisMenu: jenisMenu.id,
                  ),
                ),
              );
            },
            leading: Icon(Icons.menu),
            title: Text(
              jenisMenu.jenisMenu,
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
