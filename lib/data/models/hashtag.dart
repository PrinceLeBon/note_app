import 'package:hive/hive.dart';

part 'hive_adapters/hashtag.g.dart';

@HiveType(typeId: 2)
class HashTag {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String label;
  @HiveField(2)
  final String color;

  HashTag({
    required this.id,
    required this.label,
    required this.color,
  });

  factory HashTag.fromJson(Map<String, dynamic> json) {
    return HashTag(
      id: json['id'],
      label: json['label'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'color': color,
    };
  }
}
