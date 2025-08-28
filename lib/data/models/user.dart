import 'package:hive/hive.dart';

part 'hive_adapters/user.g.dart';

@HiveType(typeId: 3)
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nom;

  @HiveField(2)
  final String prenom;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String photo;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'photo': photo,
    };
  }

  UserModel copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? email,
    String? photo,
  }) {
    return UserModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      photo: photo ?? this.photo,
    );
  }
}
