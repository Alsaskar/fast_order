import 'package:http/http.dart' show Client;
import 'package:fast_order/models/Pesanan.dart';

class PesananService {
  final baseUrl =
      "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/order/";
  Client client = Client();
  Pesanan pesanan = new Pesanan();

  Future<List<Pesanan>> listPesanan(String status, int idPelanggan) async {
    final response = await client.get("$baseUrl/list/$status/$idPelanggan");
    if (response.statusCode == 200) {
      return pesanan.pesananFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> saveOrder(Pesanan data) async {
    final response = await client.post("$baseUrl/save", body: {
      "id_meja": data.idMeja.toString(),
      "id_menu": data.idMenu.toString(),
      "id_pelanggan": data.idPelanggan.toString(),
      "jumlah": data.jumlah.toString(),
      'total_harga': data.totalHarga.toString(),
      'catatan': data.catatan,
      'status': data.status,
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteOrder(int idPesanan, String status) async {
    final response = await client.delete("$baseUrl/delete/$idPesanan/$status");

    if (response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<bool> updateOrder(int idPelanggan) async {
    final response = await client.put("$baseUrl/accept/$idPelanggan");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
