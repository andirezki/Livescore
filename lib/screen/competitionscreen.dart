import 'package:flutter/material.dart';
import 'package:livescore/data/api/api_fixtures.dart';
import 'package:livescore/data/model/fixtures.dart';
import 'package:livescore/screen/detail_competition.dart';

class Competitionscreen extends StatefulWidget {
  const Competitionscreen({super.key});

  @override
  State<Competitionscreen> createState() => _CompetitionscreenState();
}

class _CompetitionscreenState extends State<Competitionscreen> {
  final List<Map<String, dynamic>> _leagues = [
    {
      'name': 'Premier League',
      'region': 'England',
      'icon': Icons.flag,
      'id': 39,
    },
    {
      'name': 'Bundesliga',
      'region': 'Germany',
      'icon': Icons.flag_circle,
      'id': 78,
    },
    {
      'name': 'Serie A',
      'region': 'Italy',
      'icon': Icons.flag_outlined,
      'id': 135,
    },
  ];

  List<Map<String, dynamic>> _filteredLeagues = [];
  final SoccerApi api = SoccerApi();
  List<SoccerMatch> upcomingMatches = [];
  List<SoccerMatch> pastMatches = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredLeagues = _leagues;

    // Fetch initial data for the first league (optional)
    fetchLeagueData(_leagues.first['id']);
  }

  void _filterLeagues(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLeagues = _leagues;
      } else {
        _filteredLeagues = _leagues
            .where((league) => league['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> fetchLeagueData(int leagueId) async {
    setState(() {
      isLoading = true;
    });
    try {
      String apiUrl =
          "https://v3.football.api-sports.io/fixtures?season=2024&league=$leagueId";
      List<SoccerMatch> fetchedMatches = await api.getAllMatches(apiUrl);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      // Filter upcoming matches
      List<SoccerMatch> todayMatches = fetchedMatches.where((match) {
        final matchDate = match.fixture?.date;
        return matchDate != null &&
            DateTime(matchDate.year, matchDate.month, matchDate.day) == today &&
            match.goal?.home == null &&
            match.goal?.away == null;
      }).toList();

      // Filter past matches
      List<SoccerMatch> finishedMatches = fetchedMatches.where((match) {
        final matchDate = match.fixture?.date;
        return matchDate != null &&
            matchDate.isBefore(now) &&
            match.goal?.home != null &&
            match.goal?.away != null;
      }).toList();
      // Sort matches
      todayMatches.sort((a, b) =>
          a.fixture?.date?.compareTo(b.fixture?.date ?? DateTime(0)) ?? 0);
      finishedMatches.sort((a, b) =>
          b.fixture?.date?.compareTo(a.fixture?.date ?? DateTime(0)) ?? 0);

      setState(() {
        upcomingMatches = todayMatches;
        pastMatches = finishedMatches;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching matches: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Competition', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              onChanged: _filterLeagues,
              decoration: InputDecoration(
                hintText: 'Search for competition, club...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Tabs for Top Competitions
            const Text(
              'Top Competitions',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredLeagues.length,
                itemBuilder: (context, index) {
                  final league = _filteredLeagues[index];
                  return _buildCompetitionTile(
                    league['name'],
                    league['region'],
                    league['icon'],
                    league['id'],
                  );
                },
              ),
            ),
            if (isLoading) const Center(child: CircularProgressIndicator())
            // else if (Match.)
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: Match.length,
            //       itemBuilder: (context, index) {
            //         final match = matches[index];
            //         return ListTile(
            //           title: Text(match.home?.name ?? 'Home',
            //               style: const TextStyle(color: Colors.white)),
            //           subtitle: Text(
            //               "${match.home?.name} vs ${match.away?.name}",
            //               style: const TextStyle(color: Colors.grey)),
            //         );
            //       },
            //     ),
            //   )
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitionTile(
      String title, String region, IconData icon, int leagueId) {
    return Card(
      color: const Color(0xff1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(region, style: TextStyle(color: Colors.grey[400])),
        onTap: () {
          // Navigating to the competition details screen and passing leagueId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailCompetition(
                title: title,
                region: region,
                icon: icon,
                leagueId: leagueId, // Pass the leagueId here
              ),
            ),
          );
        },
      ),
    );
  }
}
