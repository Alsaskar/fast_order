import 'package:http/http.dart' show Client;
import 'package:fast_order/models/Menu.dart';

class MenuApiService {
  final String baseUrl =
      "http://192.168.43.241/codeigniter_4/api_fastorder/public/index.php/menu/";
  Client client = Client();
  Menu menu = new Menu();

  Future<List<Menu>> getMenu(int idJenis) async {
    final response = await client.get("$baseUrl/$idJenis");
    if (response.statusCode == 200) {
      return menu.menuFromJson(response.body);
    } else {
      return null;
    }
  }
}
