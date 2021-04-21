import 'package:fast_order/models/Meja.dart';
import 'package:http/http.dart' show Client;

class MejaApiService {
  final String baseUrl =
      "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/meja/";
  Client client = Client();
  Meja meja = new Meja();

  Future<List<Meja>> getMeja() async {
    final response = await client.get("$baseUrl/show");
    if (response.statusCode == 200) {
      return meja.mejaFromJson(response.body);
    } else {
      return null;
    }
  }

  // Future<Meja> getMejaId(int id) async {
  //   final response = await client.get("$baseUrl/meja/get/$id");

  //   if (response.statusCode == 200) {
  //     final data = Meja.fromJson(json.decode(response.body));
  //     return data;
  //   } else {
  //     return null;
  //   }
  // }
}
