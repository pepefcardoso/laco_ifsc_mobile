import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/services/location_service.dart';
import '../core/services/weather_service.dart';
import '../core/services/firestore_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  final FirestoreService _firestoreService = FirestoreService();

  Position? _currentPosition;
  String? _cityName;
  Map<String, dynamic>? _weatherInfo;
  bool _isLoading = false;

  Position? get currentPosition => _currentPosition;
  String? get cityName => _cityName;
  Map<String, dynamic>? get weatherInfo => _weatherInfo;
  bool get isLoading => _isLoading;

  Future<void> updateLocationAndWeather(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
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
      _isLoading = false;
      notifyListeners();
    }
  }
}
