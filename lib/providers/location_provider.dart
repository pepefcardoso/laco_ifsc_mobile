import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/services/location_service.dart';
import '../core/services/weather_service.dart';
import '../core/services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/member_location_data.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  final FirestoreService _firestoreService = FirestoreService();

  Position? _currentPosition;
  String? _cityName;
  Map<String, dynamic>? _weatherInfo;
  bool _isLoading = false;
  String? _errorMessage;
  LocationPermission? _permissionStatus;
  Map<String, MemberLocationData> _memberLocations = {};

  Position? get currentPosition => _currentPosition;
  String? get cityName => _cityName;
  Map<String, dynamic>? get weatherInfo => _weatherInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LocationPermission? get permissionStatus => _permissionStatus;
  
  List<MemberLocationData> get membersWithLocation => _memberLocations.values.toList();

  Future<void> updateLocationAndWeather(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _permissionStatus = await _locationService.getPermissionStatus();
      _currentPosition = await _locationService.getCurrentLocation();
      
      if (_currentPosition != null) {
        _cityName = await _locationService.getCityName(_currentPosition!.latitude, _currentPosition!.longitude);
        _weatherInfo = await _weatherService.getWeather(_currentPosition!.latitude, _currentPosition!.longitude);
        
        GeoPoint locationPoint = GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude);
        await _firestoreService.updateUserLocationAndSeen(userId, locationPoint);
      } else {
        await _firestoreService.updateUserLocationAndSeen(userId, null);
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMembersLocations(List<UserModel> members) async {
    _memberLocations.clear();
    
    for (var member in members) {
      if (member.lastLocation != null) {
        String? cityName = await _locationService.getCityName(
          member.lastLocation!.latitude, 
          member.lastLocation!.longitude
        );
        
        Map<String, dynamic>? weather = await _weatherService.getWeather(
          member.lastLocation!.latitude, 
          member.lastLocation!.longitude
        );

        _memberLocations[member.id] = MemberLocationData(
          id: member.id,
          name: member.name,
          photoUrl: member.photoUrl,
          latitude: member.lastLocation!.latitude,
          longitude: member.lastLocation!.longitude,
          cityName: cityName,
          temperature: weather?['temperature']?.toDouble(),
          weatherIcon: weather?['icon'],
          weatherCondition: weather?['condition'],
          lastSeen: member.lastLocation != null ? member.lastSeen : null,
        );
      }
    }
    notifyListeners();
  }
}
