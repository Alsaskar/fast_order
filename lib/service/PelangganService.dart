import 'package:http/http.dart' show Client;
import 'package:fast_order/models/Pelanggan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PelangganService {
  final baseUrl =
      "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/pelanggan/";
  Client client = Client();
  Pelanggan pelanggan = new Pelanggan();
  SharedPreferences sharedPreferences;

  // ambil data yang sedang login
  Future<Pelanggan> getPelanggan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String idPelanggan = sharedPreferences.getString("id_users");
    final response = await client.get("$baseUrl/get/$idPelanggan");

    if (response.statusCode == 200) {
      final data = Pelanggan.fromJson(json.decode(response.body));
      return data;
    } else {
      return null;
    }
  }
}
