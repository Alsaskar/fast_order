import 'dart:convert';

class Menu {
  int id, harga, idJenis, stock;
  String nama, tipe, photo, deskripsi;

  Menu({
    this.id,
    this.harga,
    this.stock,
    this.nama,
    this.tipe,
    this.photo,
    this.deskripsi,
  });

  factory Menu.fromJson(Map<String, dynamic> map) {
    return Menu(
      id: map["id"],
      harga: map["harga"],
      stock: map["stock"],
      nama: map["nama"],
      tipe: map["tipe"],
      photo: map["photo"],
      deskripsi: map["deskripsi"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'harga': harga,
      'stock': stock,
      'nama': nama,
      'tipe': tipe,
      'photo': photo,
      'deskripsi': deskripsi
    };
  }

  @override
  String toString() {
    return 'Menu{id: $id, harga: $harga, stock: $stock, nama: $nama, tipe: $tipe, photo: $photo, deskripsi: $deskripsi}';
  }

  List<Menu> menuFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Menu>.from(data.map((item) => Menu.fromJson(item)));
  }

  String userToJson(Menu data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
