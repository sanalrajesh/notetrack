import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {

  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String subject;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  String category;

  @HiveField(5)
  bool isStarred;

  Note({
    required this.title,
    required this.description,
    required this.subject,
    DateTime? createdAt,
    this.category = 'IDEAS',
    this.isStarred = false,
  }) : createdAt = createdAt ?? DateTime.now();
}