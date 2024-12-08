import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/data/model/topscore.dart';

class Topscoreapi {
  static const String _baseUrl = "https://v3.football.api-sports.io/";
  static const Map<String, String> headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "c3d1cc51874e3ccac0a8fc3d03d476e6",
  };

  // Cache variables
  List<TopscoreModel>? _cachedMatches;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(seconds: 300); // Cache for 5 minutes

  // Method to get scorers for a specific match
  Future<List<TopscoreModel>> getForSelected({required int selectedSeason, required int selectedSLeague}) async {
    final String apiUrl =
        "${_baseUrl}players/topscorers?season=$selectedSeason&league=$selectedSLeague"; // Fixed URL format

    try {
      final Uri uri = Uri.parse(apiUrl);
      final http.Response res = await http.get(uri, headers: headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        print('Response body: $body');

        final List<dynamic> eventsList = body['response'] ?? [];
        List<TopscoreModel> standing = eventsList
            .map((dynamic item) => TopscoreModel.fromJson(item))
            .toList();

        return standing;
      } else {
        throw Exception("Failed to fetch scorer data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching scorer data: $e");
    }
  }

  // Method to get all matches
  Future<List<TopscoreModel>> getAllMatches(String apiUrl) async {
    if (_cachedMatches != null && _cacheTime != null) {
      final isCacheValid = DateTime.now().difference(_cacheTime!) < _cacheDuration;
      if (isCacheValid) {
        return _cachedMatches!; // Return cached data
      }
    }

    final Uri uri = Uri.parse(apiUrl);
    final http.Response res = await http.get(uri, headers: headers);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      // print('Response body: $body');

      final List<dynamic> matchesList = body['response'] ?? [];
      List<TopscoreModel> standing =
          matchesList.map((dynamic item) => TopscoreModel.fromJson(item)).toList();

      _cachedMatches = standing;
      _cacheTime = DateTime.now();

      return standing;
    } else {
      throw Exception("Failed to load fixtures: ${res.statusCode}");
    }
  }
}
