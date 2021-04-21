import 'package:http/http.dart' show Client;
import 'package:fast_order/models/JenisMenu.dart';

class JenisMenuApiService {
  final String baseUrl =
      "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/jenis/";
  Client client = Client();
  JenisMenu jenisMenu = new JenisMenu();

  Future<List<JenisMenu>> getJenisMenu() async {
    final response = await client.get("$baseUrl/menu");
    if (response.statusCode == 200) {
      return jenisMenu.mejaFromJson(response.body);
    } else {
      return null;
    }
  }
}
