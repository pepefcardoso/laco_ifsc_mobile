import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
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
      // Stub location and weather retrieval
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
