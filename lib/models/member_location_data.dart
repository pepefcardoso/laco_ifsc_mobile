import 'package:cloud_firestore/cloud_firestore.dart';

class MemberLocationData {
  final String id;
  final String name;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final String? cityName;
  final double? temperature;
  final String? weatherIcon;
  final String? weatherCondition;
  final Timestamp? lastSeen;

  MemberLocationData({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.temperature,
    this.weatherIcon,
    this.weatherCondition,
    this.lastSeen,
  });
}
