import 'dart:convert';

class JenisMenu {
  int id;
  String jenisMenu;

  JenisMenu({this.id, this.jenisMenu});

  factory JenisMenu.fromJson(Map<String, dynamic> map) {
    return JenisMenu(
      id: map['id'],
      jenisMenu: map['nama_jenis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_jenis': jenisMenu,
    };
  }

  @override
  String toString() {
    return 'JenisMenu{id: $id, nama_jenis: $jenisMenu}';
  }

  List<JenisMenu> mejaFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<JenisMenu>.from(data.map((item) => JenisMenu.fromJson(item)));
  }

  String userToJson(JenisMenu data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
