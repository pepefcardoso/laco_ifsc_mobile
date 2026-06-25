import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart';

class WeatherService {
  Future<Map<String, dynamic>?> getWeather(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=${ApiKeys.openWeatherApiKey}&units=metric');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'temperature': data['main']['temp'],
          'condition': data['weather'][0]['main'], // Ex: "Clear", "Clouds", "Rain"
          'icon': data['weather'][0]['icon'],
        };
      }
    } catch (e) {
      // Falha silenciosa para não quebrar o app caso a API falhe ou a chave esteja errada
      return null;
    }
    return null;
  }
}
