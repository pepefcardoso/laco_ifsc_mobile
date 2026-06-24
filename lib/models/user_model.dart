import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String photoUrl;
  final String email;
  final String groupId;
  final GeoPoint? lastLocation;
  final Timestamp? lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.email,
    required this.groupId,
    this.lastLocation,
    this.lastSeen,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      email: map['email'] ?? '',
      groupId: map['groupId'] ?? '',
      lastLocation: map['lastLocation'] as GeoPoint?,
      lastSeen: map['lastSeen'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'email': email,
      'groupId': groupId,
      'lastLocation': lastLocation,
      'lastSeen': lastSeen,
    };
  }
}
