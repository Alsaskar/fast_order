import 'dart:convert';

class Pelanggan {
  int id;
  String firstname, lastname, noHp, photo;

  Pelanggan({this.id, this.firstname, this.lastname, this.noHp, this.photo});

  factory Pelanggan.fromJson(Map<String, dynamic> map) {
    return Pelanggan(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      noHp: map['no_hp'],
      photo: map['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'noHp': noHp,
      'photo': photo,
    };
  }

  @override
  String toString() {
    return 'Pelanggan{id: $id, firstname: $firstname, lastname: $lastname, noHp: $noHp, photo: $photo}';
  }

  List<Pelanggan> pelangganFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Pelanggan>.from(data.map((item) => Pelanggan.fromJson(item)));
  }

  String pelangganToJson(Pelanggan data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}
