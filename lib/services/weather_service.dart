import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String apiKey =
      'f5fc60a59f66ba2c5f931af55b412bf0'; // Replace with your API key
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String cityName) async {
    final Uri uri =
        Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the JSON response and convert it to a Weather object
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        // Handle different HTTP status codes
        throw _handleError(response.statusCode);
      }
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('Failed to load weather data: $e');
    }
  }

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check the city name.';
      case 401:
        return 'Unauthorized. Please check your API key.';
      case 404:
        return 'City not found. Please check the city name.';
      case 500:
        return 'Internal server error. Please try again later.';
      default:
        return 'Failed to load weather data. Status code: $statusCode';
    }
  }
}
