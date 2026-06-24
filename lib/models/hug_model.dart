import 'package:cloud_firestore/cloud_firestore.dart';

class HugModel {
  final String id;
  final String fromUid;
  final String toUid;
  final String groupId;
  final Timestamp sentAt;

  HugModel({
    required this.id,
    required this.fromUid,
    required this.toUid,
    required this.groupId,
    required this.sentAt,
  });

  factory HugModel.fromMap(Map<String, dynamic> map, String id) {
    return HugModel(
      id: id,
      fromUid: map['fromUid'] ?? '',
      toUid: map['toUid'] ?? '',
      groupId: map['groupId'] ?? '',
      sentAt: map['sentAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUid': fromUid,
      'toUid': toUid,
      'groupId': groupId,
      'sentAt': sentAt,
    };
  }
}
