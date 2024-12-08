// ignore_for_file: unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/data/model/fixtures.dart';
// import 'package:livescore/data/model/soccermatch.dart';

class Fixturesapi {
  static const String _baseUrl = "https://v3.football.api-sports.io/";
  static const Map<String, String> headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "c3d1cc51874e3ccac0a8fc3d03d476e6",
  };

  List<SoccerMatch>? _cachedMatches;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(seconds: 30);

  Future<List<SoccerMatch>> getData(
      {required int selectedLeagueId,}) async {
    final String apiUrl =
          "https://v3.football.api-sports.io/fixtures?season=2024&league=$selectedLeagueId";

        
    try {
      final Uri uri = Uri.parse(apiUrl);
      final http.Response res = await http.get(uri, headers: headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // print('Response body: $body');

        final List<dynamic> eventsList = body['response'] ?? [];
        List<SoccerMatch> soccermatch =
            eventsList.map((dynamic item) => SoccerMatch.fromJson(item)).toList();

        return soccermatch;
      } else {
        throw Exception("Failed to fetch scorer data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching scorer data: $e");
    }
  }

  Future<List<SoccerMatch>> getAllMatches(String apiUrl) async {
    if (_cachedMatches != null && _cacheTime != null) {
      final isCacheValid =
          DateTime.now().difference(_cacheTime!) < _cacheDuration;
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
      List<SoccerMatch> soccermatch =
          matchesList.map((dynamic item) => SoccerMatch.fromJson(item)).toList();

      _cachedMatches = soccermatch;
      _cacheTime = DateTime.now();

      return soccermatch;
    } else {
      throw Exception("Failed to load fixtures: ${res.statusCode}");
    }
  }
}
