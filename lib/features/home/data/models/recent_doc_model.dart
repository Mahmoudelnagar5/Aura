import 'package:hive/hive.dart';

part 'recent_doc_model.g.dart';

@HiveType(typeId: 0)
class RecentDocModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;
  @HiveField(2)
  final DateTime uploadDate;

  RecentDocModel({
    required this.name,
    required this.path,
    required this.uploadDate,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'path': path,
        'uploadDate': uploadDate.toIso8601String(),
      };

  factory RecentDocModel.fromMap(Map map) => RecentDocModel(
        name: map['name'],
        path: map['path'],
        uploadDate: DateTime.parse(map['uploadDate']),
      );
}
