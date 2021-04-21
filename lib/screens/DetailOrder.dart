import 'package:fast_order/screens/StartOrder.dart';
import 'package:flutter/material.dart';
import 'package:fast_order/models/Menu.dart';
import 'package:fast_order/service/MenuService.dart';

class DetailOrder extends StatefulWidget {
  String noMeja, namaJenis;
  int idJenisMenu, idMeja;

  DetailOrder(
      {this.noMeja, this.namaJenis, this.idJenisMenu, this.idMeja, Key key})
      : super(key: key);

  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  MenuApiService apiService;

  @override
  void initState() {
    apiService = MenuApiService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Menu " + widget.namaJenis),
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

  Widget orderMenu() {
    return Column(
      children: [
        Text(
          "Silahkan untuk memesan menu-menu yang telah tersedia",
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        Divider(
          color: Colors.black,
        ),
        Expanded(
          child: FutureBuilder(
            future: apiService.getMenu(widget.idJenisMenu),
            builder:
                (BuildContext context, AsyncSnapshot<List<Menu>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Something wrong with message: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<Menu> tables = snapshot.data;
                return Container(
                  child: listBuildView(tables),
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
  }

  Widget listBuildView(List<Menu> tables) {
    if (tables != null) {
      // jika data ada
      return ListView.separated(
        separatorBuilder: (BuildContext context, int i) =>
            Divider(color: Colors.grey[400]),
        itemCount: tables.length,
        itemBuilder: (context, index) {
          Menu menu = tables[index];
          return Ink(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartOrder(
                      namaMenu: menu.nama,
                      hargaMenu: menu.harga,
                      stockMenu: menu.stock,
                      noMeja: widget.noMeja,
                      idMeja: widget.idMeja,
                      idMenu: menu.id,
                    ),
                  ),
                );
              },
              leading: menu.photo == ''
                  ? Icon(Icons.fastfood)
                  : Image.network(
                      "http://192.168.43.241/fast_order/assets/images/menu/" +
                          menu.photo,
                      height: 100.0,
                      width: 80.0,
                    ),
              title: Text(
                menu.nama,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                "Harga : " + menu.harga.toString(),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  menu.stock == 0
                      ? Text(
                          "Telah habis",
                          style: TextStyle(color: Colors.red),
                        )
                      : Text("Tersisa : " + menu.stock.toString()),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // jika data tidak ada
      return Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(05.0),
              child: Image.asset(
                "assets/images/notfound_food.png",
                height: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(05.0),
              child: Text(
                "Maaf Jenis Menu yang dipilih belum ada Menu. Silahkan kembali dan pilih jenis menu yang lain",
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Pilih Jenis Menu Lain",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
            ),
          ],
        ),
      );
    }
  }
}
