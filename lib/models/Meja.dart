import 'dart:convert';

class Meja {
  int id;
  String noMeja;
  String statusMeja;

  Meja({this.id, this.noMeja, this.statusMeja});

  factory Meja.fromJson(Map<String, dynamic> map) {
    return Meja(
      id: map['id'],
      noMeja: map['no_meja'],
      statusMeja: map['status_meja'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomor_meja': noMeja,
      'status_meja': statusMeja,
    };
  }

  @override
  String toString() {
    return 'Meja{id: $id, noMeja: $noMeja, statusMeja: $statusMeja}';
  }

  List<Meja> mejaFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Meja>.from(data.map((item) => Meja.fromJson(item)));
  }

  String userToJson(Meja data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
