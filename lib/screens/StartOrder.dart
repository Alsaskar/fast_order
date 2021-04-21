import 'package:flutter/material.dart';
import 'package:fast_order/models/Pelanggan.dart';
import 'package:fast_order/service/PelangganService.dart';
import 'package:fast_order/models/Pesanan.dart';
import 'package:fast_order/service/PesananService.dart';

class StartOrder extends StatefulWidget {
  String namaMenu, noMeja;
  int hargaMenu, stockMenu, idMeja, idMenu;

  StartOrder({
    this.namaMenu,
    this.hargaMenu,
    this.stockMenu,
    this.noMeja,
    this.idMeja,
    this.idMenu,
    Key key,
  }) : super(key: key);

  @override
  _StartOrderState createState() => _StartOrderState();
}

class _StartOrderState extends State<StartOrder> {
  final _formKey = GlobalKey<FormState>();
  PelangganService apiService;
  PesananService pesananService;
  Pelanggan pelanggan;
  bool _isLoading = false;

  TextEditingController jumlah = TextEditingController();
  TextEditingController catatan = TextEditingController();

  void initState() {
    apiService = PelangganService();
    pesananService = PesananService();
    super.initState();
  }

  void showContent(String title, String msg) {
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
                Navigator.pop(context);
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
      appBar: AppBar(
        title: Text("Mulai Memesan"),
      ),
      body: SingleChildScrollView(
        child: widget.stockMenu == 0 ? noPesan() : startOrder(),
      ),
    );
  }

  // tidak bisa pesan
  Widget noPesan() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Image.asset(
            "assets/images/sorry.png",
            height: 200.0,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Text(
            "Maaf menu ini sudah habis, silahkan untuk memesan menu lain",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Pilih Menu Lain",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  // memulai pesan
  Widget startOrder() {
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

          // jika data tidak kosong
          if (pelanggan.id != 0) {
            return Container(
              padding: EdgeInsets.only(top: 20.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            "Nama Menu : " + widget.namaMenu,
                          ),
                          Text(
                            "Harga : " + widget.hargaMenu.toString(),
                          ),
                          inputJumlah(),
                          inputCatatan(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    // proses data
                                    _formKey.currentState.save();
                                    Pesanan pesanan = Pesanan();

                                    // data pesanan
                                    pesanan.idMeja = widget.idMeja;
                                    pesanan.idMenu = widget.idMenu;
                                    pesanan.idPelanggan = pelanggan.id;
                                    pesanan.jumlah = int.parse(jumlah.text);
                                    pesanan.catatan = catatan.text;
                                    pesanan.status = "pending";
                                    pesanan.totalHarga =
                                        int.parse(jumlah.text) *
                                            widget.hargaMenu;

                                    setState(() {
                                      _isLoading = true;
                                    });

                                    if (int.parse(jumlah.text) >
                                        widget.stockMenu) {
                                      // jika jumlah lebih besar dari stock
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      jumlah.clear();
                                      showContent("Oopps...",
                                          "Maaf, jumlah yang dimasukkan melebihi stock");
                                    } else {
                                      // simpan data ke database
                                      pesananService.saveOrder(pesanan).then(
                                            (data) => {
                                              if (data == true)
                                                {
                                                  setState(() {
                                                    _isLoading = false;

                                                    jumlah.clear();
                                                    catatan.clear();
                                                    showContent("Berhasil",
                                                        "Anda berhasil menambahkan pesanan ke cart. Silahkan pesan menu yang lain");
                                                  })
                                                }
                                            },
                                          );
                                    }
                                  }
                                },
                                color: Colors.blue,
                                child: Text(
                                  "Simpan Pesanan",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.red,
                                child: Text(
                                  "Cari Menu Lain",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          } else {
            return Text("User Not Found");
          }
        } else {
          return Center(
            child: Container(),
          );
        }
      },
    );
  }

  Widget inputJumlah() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: jumlah,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Mau Pesan Berapa ?",
          labelStyle: TextStyle(color: Colors.blue),
          contentPadding:
              const EdgeInsets.only(left: 10.0, bottom: 7.0, top: 7.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(05.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(05.0),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget inputCatatan() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: catatan,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: "Masukkan sedikit catatan",
          labelStyle: TextStyle(color: Colors.blue),
          contentPadding:
              const EdgeInsets.only(left: 10.0, bottom: 7.0, top: 7.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(05.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(05.0),
          ),
        ),
      ),
    );
  }
}
