import 'package:hive/hive.dart';

part 'hive_adapters/note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<String> hashtagsId;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String note;
  @HiveField(5)
  final DateTime dateOfCreation;

  Note({
    required this.id,
    required this.hashtagsId,
    required this.userId,
    required this.title,
    required this.note,
    required this.dateOfCreation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hashtagsId': hashtagsId,
      'userId': userId,
      'title': title,
      'note': note,
      'dateOfCreation': dateOfCreation.millisecondsSinceEpoch,
    };
  }

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      hashtagsId: List<String>.from(json['hashtagsId']),
      userId: json['userId'],
      title: json['title'],
      note: json['note'],
      dateOfCreation:
          DateTime.fromMillisecondsSinceEpoch(json['dateOfCreation']),
    );
  }
}
