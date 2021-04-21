import 'dart:convert';

class Pesanan {
  int id, idMenu, idMeja, idPelanggan, jumlah, totalHarga, hargaMenu;
  String catatan, status, noMeja, namaMenu, tipeMenu;

  Pesanan({
    this.id,
    this.idMeja,
    this.noMeja,
    this.idMenu,
    this.idPelanggan,
    this.jumlah,
    this.totalHarga,
    this.catatan,
    this.status,
    this.namaMenu,
    this.hargaMenu,
    this.tipeMenu,
  });

  factory Pesanan.fromJson(Map<String, dynamic> map) {
    return Pesanan(
      id: map['id'],
      idMenu: int.parse(map['id_menu'].toString()),
      idMeja: int.parse(map['id_meja'].toString()),
      idPelanggan: int.parse(map['id_pelanggan'].toString()),
      jumlah: int.parse(map['jumlah'].toString()),
      totalHarga: int.parse(map['total_harga'].toString()),
      catatan: map['catatan'],
      status: map['status'],
      noMeja: map['nomor_meja'],
      namaMenu: map['nama_menu'],
      hargaMenu: int.parse(map['harga_menu'].toString()),
      tipeMenu: map['tipe_menu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_menu': idMenu,
      'id_meja': idMeja,
      'id_pelanggan': idPelanggan,
      'jumlah': jumlah,
      'total_harga': totalHarga,
      'catatan': catatan,
      'status': status,
      'nomor_meja': noMeja,
      'nama_menu': namaMenu,
      'harga_menu': hargaMenu,
      'tipe_menu': tipeMenu,
    };
  }

  @override
  String toString() {
    return 'Pesanan{id: $id, id_menu: $idMenu, id_meja: $idMeja, nomor_meja: $noMeja, id_pelanggan: $idPelanggan, jumlah: $jumlah, total_harga: $totalHarga, catatan: $catatan, status: $status, nama_menu: $namaMenu, harga_menu: $hargaMenu, tipe_menu: $tipeMenu}';
  }

  List<Pesanan> pesananFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Pesanan>.from(data.map((item) => Pesanan.fromJson(item)));
  }

  String pesananToJson(Pesanan data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
