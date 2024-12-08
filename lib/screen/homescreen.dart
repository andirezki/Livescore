import 'dart:async';
import 'package:flutter/material.dart';
import 'package:livescore/data/api/api_fixtures.dart';
import 'package:livescore/data/model/fixtures.dart';
import 'package:livescore/screen/detail_score.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;
  bool _isVisible = true;
  late Timer _timer;
  final SoccerApi api = SoccerApi();
  List<SoccerMatch> upcomingMatches = [];
  List<SoccerMatch> pastMatches = [];
  bool isLoading = true;

  static const List<String> _leagues = [
    'Premier League',
    'Bundesliga',
    'Serie A',
  ];

  final Map<String, int> _leagueIds = {
    'Premier League': 39,
    'Bundesliga': 78,
    'Serie A': 135,
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchAllMatches();
    });
    fetchAllMatches();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      isLoading = true;
    });
    fetchAllMatches();
  }

  Future<void> fetchAllMatches() async {
    try {
      String selectedLeague = _leagues[_selectedIndex];
      int leagueId = _leagueIds[selectedLeague] ?? 39;
      String apiUrl =
          "https://v3.football.api-sports.io/fixtures?season=2024&league=$leagueId";
      List<SoccerMatch> matches = await api.getAllMatches(apiUrl);

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      // Filter matches that are scheduled for today and are upcoming
      List<SoccerMatch> todayMatches = matches.where((match) {
        final matchDate = match.fixture?.date;
        return matchDate != null &&
            DateTime(matchDate.year, matchDate.month, matchDate.day) == today &&
            match.goal?.home == null &&
            match.goal?.away == null; // Check if match has not been played
      }).toList();

      // Filter past matches (already played)
      List<SoccerMatch> finishedMatches = matches.where((match) {
        final matchDate = match.fixture?.date;
        return matchDate != null &&
            matchDate.isBefore(now) &&
            match.goal?.home != null &&
            match.goal?.away != null; // Check if match has been played
      }).toList();

      // Sort the matches (upcoming and finished)
      todayMatches.sort((a, b) =>
          a.fixture?.date?.compareTo(b.fixture?.date ?? DateTime(0)) ?? 0);
      finishedMatches.sort((a, b) =>
          b.fixture?.date?.compareTo(a.fixture?.date ?? DateTime(0)) ?? 0);

      setState(() {
        upcomingMatches = todayMatches;
        pastMatches = finishedMatches;
        isLoading = false;
      });

      print("Fetched and Sorted Matches: $upcomingMatches");
      print("Fetched and Sorted Past Matches: $pastMatches");
    } catch (e) {
      print("Error fetching matches: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Livescore', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLeagueTabs(),
          const SizedBox(height: 20),
          const Text(
            'Live Now',
            style: TextStyle(color: Color(0xFFB71C1C), fontSize: 24),
          ),
          const SizedBox(height: 20),
          buildLiveMatchSection(),
          const SizedBox(height: 20),
          const Text(
            'Past Matches',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pastMatches.length,
              itemBuilder: (context, index) {
                final match = pastMatches[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: _buildMatchTile(
                    match.home?.name ?? 'Home Team',
                    match.goal?.home?.toString() ?? 'N/A',
                    match.home?.logoUrl ?? '',
                    match.away?.name ?? 'Away Team',
                    match.goal?.away?.toString() ?? 'N/A',
                    match.away?.logoUrl ?? '',
                    match,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLeagueTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_leagues.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(
                _leagues[index],
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.white : Colors.grey,
                ),
              ),
              selected: _selectedIndex == index,
              onSelected: (selected) {
                _onTabSelected(index);
              },
              selectedColor: const Color(0xff1732bb),
              backgroundColor: Colors.grey[900],
            ),
          );
        }),
      ),
    );
  }

  Widget buildLiveMatchSection() {
    if (upcomingMatches.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final match = upcomingMatches[0];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScore(
              match: match,
              fixtureId: match.fixture?.id ?? 0,
              leagueId: match.leagues?.id ?? 0,
              seasonId: match.leagues?.season ?? 0,
              homeId: match.home?.id ?? 0,
              awayId: match.away?.id ?? 0,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              _leagues[_selectedIndex],
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamColumn(
                    match.home?.name ?? 'Home Team', match.home?.logoUrl),
                AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    '${match.goal?.home == null ? 'N/A' : match.goal?.home} - ${match.goal?.away == null ? 'N/A' : match.goal?.away}',
                    style: const TextStyle(
                      color: Color(0xFFB71C1C),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildTeamColumn(
                    match.away?.name ?? 'Away Team', match.away?.logoUrl),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamColumn(String teamName, String? logoUrl) {
    return Column(
      children: [
        logoUrl != null
            ? Image.network(
                logoUrl,
                width: 50,
                height: 50,
              )
            : const Icon(Icons.sports_soccer, color: Colors.white, size: 50),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            teamName,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildMatchTile(
    String homeTeam,
    String homeScore,
    String homeLogo,
    String awayTeam,
    String awayScore,
    String awayLogo,
    SoccerMatch match, // Pass match data for details
  ) {
    return InkWell(
      onTap: () {
        print(
            "Navigating to DetailScore with fixtureId: ${match.fixture?.id ?? 215662}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScore(
              match: match,
              fixtureId: match.fixture!.id ?? 0,
              leagueId: match.leagues?.id ?? 0,
              seasonId: match.leagues?.season ?? 0,
              homeId: match.home?.id ?? 0,
              awayId: match.away?.id ?? 0,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _leagues[_selectedIndex],
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamColumn(homeTeam, homeLogo),
                Text(
                  '$homeScore - $awayScore',
                  style: const TextStyle(
                    color: Color(0xFFB71C1C),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                _buildTeamColumn(awayTeam, awayLogo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
