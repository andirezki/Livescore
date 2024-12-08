// import 'package:flutter/material.dart';
// import 'package:livescore/data/api/scoreer.dart'; // For Scorers
// import 'package:livescore/data/api/standingApi.dart';
// import 'package:livescore/data/model/fixtures.dart';
// import 'package:livescore/data/model/matches.dart';
// import 'package:livescore/data/model/Standing.dart'; // Model for standings

// class DetailScore extends StatefulWidget {
//   final SoccerMatch match;
//   final int fixtureId;
//   final int leagueId; // Add leagueId to fetch standings
//   final int seasonId; // Add season to fetch standings
//   final int HomeId;
//   final int AwayId;

//   const DetailScore({
//     super.key,
//     required this.match,
//     required this.fixtureId,
//     required this.leagueId, // Initialize leagueId
//     required this.seasonId,
//     required this.HomeId,
//     required this.AwayId // Initialize season
//   });

//   @override
//   State<DetailScore> createState() => DetailScoreState();
// }

// class DetailScoreState extends State<DetailScore> {
//   late Future<List<Scorer>> scorers;
//   late Future<List<StandingModel>> standings; // Future for standings

//   @override
//   void initState() {
//     super.initState();
//     // print('Fixture ID: ${widget.fixtureId}'); // Debug fixtureId
//     scorers = getScorers(); // Initialize API call for scorers
//     standings = getStandings(); // Initialize API call for standings
//   }

//   Future<List<Scorer>> getScorers() async {
//     try {
//       ScorerService scorerService = ScorerService();
//       return await scorerService.getForSelected(
//         selectedFixtureId: widget.fixtureId,
//       );
//     } catch (e) {
//       throw Exception("Failed to load scorers: $e");
//     }
//   }

//   // New method to get standings
//   Future<List<StandingModel>> getStandings() async {
//     try {
//       League leagueService = League();
//       return await leagueService.getForSelected(
//         selectedLeague: widget.leagueId,
//         selectedSeason: widget.seasonId,
//       );
//     } catch (e) {
//       throw Exception("Failed to load standings: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.black,
//         title:
//             const Text("Match Detail", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           // Section for Scorers
//           Expanded(
//             child: FutureBuilder<List<Scorer>>(
//               future: scorers,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No scorers available'));
//                 } else {
//                   final scorers = snapshot.data!;
//                   return ListView.builder(
//                     itemCount: scorers.length,
//                     itemBuilder: (context, index) {
//                       final scorer = scorers[index];
//                       return ListTile(
//                         title: Text(scorer.player?.name ?? 'Unknown Player'),
//                         subtitle:
//                             Text('Minute: ${scorer.time?.elapsedTime ?? 0}'),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//           const Divider(), // Separate Scorers and Standings sections
//           // Section for Standings
//           Expanded(
//             child: FutureBuilder<List<StandingModel>>(
//               future: standings,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('No standings available'));
//                 } else {
//                   final standings = snapshot.data!;
//                   return ListView.builder(
//                     itemCount: standings.length,
//                     itemBuilder: (context, index) {
//                       // final standing = standings[index].standing;
//                       // final league = standings[index].league;

//                       // return ListTile(
//                       //   title: Text('${standing.team.name}'),
//                       //   subtitle: Text('Rank: ${standing.rank}, Points: ${standing.points}'),
//                       //   trailing: league.logo != null
//                       //       ? Image.network(league.logo!, height: 30)
//                       //       : null,
//                       // );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
