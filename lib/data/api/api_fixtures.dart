import 'dart:convert';
import 'package:http/http.dart';
import 'package:livescore/data/model/fixtures.dart';

class SoccerApi {
  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "c3d1cc51874e3ccac0a8fc3d03d476e6",
  };

  // Cache variables
  List<SoccerMatch>? _cachedMatches;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(seconds: 5); // Cache for 5 minutes

  Future<List<SoccerMatch>> getAllMatches(String apiUrl) async {
    // Check if cached data is available and not expired
    if (_cachedMatches != null && _cacheTime != null) {
      final isCacheValid = DateTime.now().difference(_cacheTime!) < _cacheDuration;
      if (isCacheValid) {
        return _cachedMatches!; // Return cached data
      }
    }

    // If no valid cache, make a new API request
    final Uri uri = Uri.parse(apiUrl);
    final res = await get(uri, headers: headers);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      // print('hasil: $body');
      final List<dynamic> matchesList = body['response'];
      List<SoccerMatch> matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();

      // Cache the result and update cache time
      _cachedMatches = matches;
      _cacheTime = DateTime.now();

      return matches;
    } else {
      throw Exception("Failed to load fixtures");
    }
  }

  getAllLeagues(String apiUrl) {}
}
