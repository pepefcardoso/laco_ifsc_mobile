import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String code;
  final String createdBy;
  final List<String> members;
  final Timestamp createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.code,
    required this.createdBy,
    required this.members,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      createdBy: map['createdBy'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'createdBy': createdBy,
      'members': members,
      'createdAt': createdAt,
    };
  }
}
