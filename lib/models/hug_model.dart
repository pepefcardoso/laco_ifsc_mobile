import 'package:cloud_firestore/cloud_firestore.dart';

class HugModel {
  final String id;
  final String fromUid;
  final String fromName;
  final String toUid;
  final String toName;
  final String groupId;
  final Timestamp sentAt;

  HugModel({
    required this.id,
    required this.fromUid,
    required this.fromName,
    required this.toUid,
    required this.toName,
    required this.groupId,
    required this.sentAt,
  });

  factory HugModel.fromMap(Map<String, dynamic> map, String id) {
    return HugModel(
      id: id,
      fromUid: map['fromUid'] ?? '',
      fromName: map['fromName'] ?? '',
      toUid: map['toUid'] ?? '',
      toName: map['toName'] ?? '',
      groupId: map['groupId'] ?? '',
      sentAt: map['sentAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUid': fromUid,
      'fromName': fromName,
      'toUid': toUid,
      'toName': toName,
      'groupId': groupId,
      'sentAt': sentAt,
    };
  }
}
