import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String groupId;
  final String imageUrl;
  final String caption;
  final Map<String, String> reactions;
  final Timestamp createdAt;

  PostModel({
    required this.id,
    required this.authorId,
    required this.groupId,
    required this.imageUrl,
    required this.caption,
    required this.reactions,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      authorId: map['authorId'] ?? '',
      groupId: map['groupId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      caption: map['caption'] ?? '',
      reactions: Map<String, String>.from(map['reactions'] ?? {}),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'groupId': groupId,
      'imageUrl': imageUrl,
      'caption': caption,
      'reactions': reactions,
      'createdAt': createdAt,
    };
  }
}
