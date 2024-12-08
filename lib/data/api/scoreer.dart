import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/data/model/matches.dart';

class ScorerService {
  static const String _baseUrl = "https://v3.football.api-sports.io/";
  static const Map<String, String> headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "c3d1cc51874e3ccac0a8fc3d03d476e6",
  };

  // Cache variables
  List<Scorer>? _cachedMatches;
  DateTime? _cacheTime;
  final Duration _cacheDuration =
      const Duration(seconds: 5); // Cache for 5 minutes

  Future<List<Scorer>> getForSelected({required int selectedFixtureId}) async {
    final String apiUrl =
        "${_baseUrl}fixtures/events?fixture=$selectedFixtureId";

    try {
      final Uri uri = Uri.parse(apiUrl);
      final http.Response res = await http.get(uri, headers: headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // print('Response body: $body');

        final List<dynamic> eventsList = body['response'] ?? [];
        List<Scorer> scorers =
            eventsList.map((dynamic item) => Scorer.fromJson(item)).toList();

        return scorers;
      } else {
        throw Exception("Failed to fetch scorer data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching scorer data: $e");
    }
  }

  Future<List<Scorer>> getAllMatches(String apiUrl) async {
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
      List<Scorer> scorers =
          matchesList.map((dynamic item) => Scorer.fromJson(item)).toList();

      _cachedMatches = scorers;
      _cacheTime = DateTime.now();

      return scorers;
    } else {
      throw Exception("Failed to load fixtures: ${res.statusCode}");
    }
  }
}
