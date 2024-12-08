import 'dart:convert';
import 'package:http/http.dart' as http;

class SoccerApi {
  final String apiKey =
      "c3d1cc51874e3ccac0a8fc3d03d476e6"; // Ganti dengan API key Anda
  final Map<String, String> headers = {
    "x-rapidapi-host": "v3.football.api-sports.io",
    "x-rapidapi-key":
        "c3d1cc51874e3ccac0a8fc3d03d476e6" // Ganti dengan API key Anda
  };

  Future<List<dynamic>> getAllLeagues(String url) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data["response"];
    } else {
      throw Exception("Failed to load leagues");
    }
  }
}
