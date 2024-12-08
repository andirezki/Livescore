import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/data/model/head2head.dart';

class HeadtoHead {
  static const String _baseUrl = "https://v3.football.api-sports.io/";
  static const Map<String, String> headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "c3d1cc51874e3ccac0a8fc3d03d476e6",
  };

  List<Head2Head>? _cachedMatches;
  DateTime? _cacheTime;
  final Duration _cacheDuration = const Duration(seconds: 30);

  Future<List<Head2Head>> getData(
      {required int selectedHomeId,
      required int selectedAwayId,
      required int last}) async {
    final String apiUrl =
        "${_baseUrl}fixtures/headtohead?h2h=$selectedHomeId-$selectedAwayId&last=$last";

    try {
      final Uri uri = Uri.parse(apiUrl);
      final http.Response res = await http.get(uri, headers: headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // print('Response body: $body');

        final List<dynamic> eventsList = body['response'] ?? [];
        List<Head2Head> head2head =
            eventsList.map((dynamic item) => Head2Head.fromJson(item)).toList();

        return head2head;
      } else {
        throw Exception("Failed to fetch scorer data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching scorer data: $e");
    }
  }

  Future<List<Head2Head>> getAllMatches(String apiUrl) async {
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
      List<Head2Head> head2head =
          matchesList.map((dynamic item) => Head2Head.fromJson(item)).toList();

      _cachedMatches = head2head;
      _cacheTime = DateTime.now();

      return head2head;
    } else {
      throw Exception("Failed to load fixtures: ${res.statusCode}");
    }
  }
}
