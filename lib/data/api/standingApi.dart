// ignore_for_file: unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:livescore/data/model/standing.dart';

class Standing {
  static const String _baseUrl = "https://v3.football.api-sports.io/";
  static const Map<String, String> headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "c3d1cc51874e3ccac0a8fc3d03d476e6",
  };

  // Cache variables
  Standings? _cachedMatches;
  DateTime? _cacheTime;
  final Duration _cacheDuration =
      const Duration(seconds: 5); // Cache for 5 minutes

  // Method to get scorers for a specific match
  Future<List<StandingModel>> getForSelected({
    required int selectedLeague,
    required int selectedSeason,
  }) async {
    final String apiUrl =
        "${_baseUrl}standings?league=$selectedLeague&season=$selectedSeason";

    try {
      final Uri uri = Uri.parse(apiUrl);
      final http.Response res = await http.get(uri, headers: headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        // print(body);
        // Ambil array 'standings' dari respons
        final List<dynamic> responseList = body['response'] ?? [];
        if (responseList.isNotEmpty) {
          final Map<String, dynamic> league = responseList.first['league'];
          final List<dynamic> standingsData = league['standings'];

          // Parse ke List<Standing>
          final List<StandingModel> standings = (standingsData[0] as List)
              .map((item) => StandingModel.fromJson(item))
              .toList();

          return standings;
        } else {
          throw Exception("Standings not found in response");
        }
      } else {
        throw Exception("Failed to fetch data: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
}
