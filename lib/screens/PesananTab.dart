import 'package:fast_order/service/PesananService.dart';
import 'package:flutter/material.dart';
import 'package:fast_order/models/Pelanggan.dart';
import 'package:fast_order/service/PelangganService.dart';
import 'package:fast_order/models/Pesanan.dart';

class PesananTab extends StatefulWidget {
  PesananTab({Key key}) : super(key: key);

  @override
  _PesananTabState createState() => _PesananTabState();
}

class _PesananTabState extends State<PesananTab> {
  PelangganService pelangganService;
  PesananService pesananService;
  Pelanggan pelanggan;
  bool _isLoading = false;

  void initState() {
    pelangganService = PelangganService();
    pesananService = PesananService();
    super.initState();
  }

  // pesan untuk memesan menu
  confirmPesanMenu(BuildContext context, int idPelanggan) {
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ya"),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          _isLoading = true;
        });

        pesananService.updateOrder(idPelanggan).then(
              (data) => {
                if (data == true)
                  {
                    setState(() {
                      _isLoading = false;
                      _showContent(
                          "Berhasil", "Pesanan Anda telah berhasil dipesan");
                    })
                  }
              },
            );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Yakin ingin memesan menu yang sudah dipesan ?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // pesan untuk membatalkan pesanan
  confirmBatalMenu(BuildContext context, int idPelanggan) {
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ya"),
      onPressed: () {
        Navigator.pop(context);
        setState(() {
          _isLoading = true;
        });

        pesananService.deleteOrder(idPelanggan, 'pending').then(
              (data) => {
                if (data == 1)
                  {
                    setState(() {
                      _isLoading = false;
                      _showContent(
                          "Berhasil", "Anda berhasil membatalkan pesanan");
                    })
                  }
              },
            );
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Ingin membatalkan pesanan ?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
    return FutureBuilder(
      future: pelangganService.getPelanggan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          // tampung data dari server
          pelanggan = snapshot.data; // ambil data pelanggan yg login

          return Container(
            child: FutureBuilder(
              future: pesananService.listPesanan("pending", pelanggan.id),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pesanan>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something wrong with message: ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<Pesanan> orders = snapshot.data;

                  return _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            orders != null ? headerTop() : Container(),
                            Expanded(
                              child: _listBuildView(orders),
                            ),
                          ],
                        );
                } else {
                  return Center(
                    child: Container(),
                  );
                }
              },
            ),
          );
        } else {
          return Center(
            child: Container(),
          );
        }
      },
    );
  }

  Widget btnPesan(int idPelanggan) {
    return RaisedButton(
      onPressed: () {
        confirmPesanMenu(context, idPelanggan);
      },
      color: Colors.blue,
      child: Text(
        "Pesan Sekarang",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget btnBatal(int idPelanggan) {
    return RaisedButton(
      onPressed: () {
        confirmBatalMenu(context, idPelanggan);
      },
      color: Colors.red,
      child: Text(
        "Batal Memesan",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  // untuk menampilkan tombol pesan dan batalkan pesan
  Widget headerTop() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              btnPesan(pelanggan.id),
              btnBatal(pelanggan.id),
            ],
          ),
        ),
        Divider(
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _listBuildView(List<Pesanan> orders) {
    if (orders != null) {
      return ListView.separated(
        separatorBuilder: (BuildContext context, int i) =>
            Divider(color: Colors.grey[400]),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          Pesanan pesanan = orders[index];

          return ListTile(
            onTap: () {},
            leading: Icon(Icons.menu),
            title: Text(
              pesanan.namaMenu,
              style: TextStyle(color: Colors.black),
            ),
            subtitle:
                Text(pesanan.catatan == "" ? "Tanpa catatan" : pesanan.catatan),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Meja : " + pesanan.noMeja),
                Text("Harga : " + pesanan.hargaMenu.toString()),
              ],
            ),
          );
        },
      );
    } else {
      return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset("assets/images/notfound_food.png", height: 250.0),
            Padding(padding: EdgeInsets.only(bottom: 18.0)),
            Text(
              "Anda belum memesan pesanan. Silahkan untuk memesan pesanan terlebih dahulu",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),
      );
    }
  }
}
