// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livescore/data/api/FixturesApi.dart';
import 'package:livescore/data/api/standingApi.dart';
import 'package:livescore/data/api/topscoreApi.dart';
import 'package:livescore/data/model/fixtures.dart';
import 'package:livescore/data/model/standing.dart';
import 'package:livescore/data/model/topscore.dart';

class DetailCompetition extends StatefulWidget {
  final String title;
  final String region;
  final int leagueId;
  final dynamic icon;

  const DetailCompetition(
      {super.key,
      required this.title,
      required this.region,
      required this.leagueId,
      required this.icon});

  @override
  State<DetailCompetition> createState() => _DetailCompetitionState();
}

class _DetailCompetitionState extends State<DetailCompetition> {
  late Future<List<SoccerMatch>> soccermatch;
  late Future<List<StandingModel>> standings;
  late Future<List<TopscoreModel>> topscore;

  @override
  void initState() {
    super.initState();
    soccermatch = getSoccermatch();
    standings = getStandings();
    topscore = getTopScore();
  }

  Future<List<SoccerMatch>> getSoccermatch() async {
    try {
      Fixturesapi fixturesapi = Fixturesapi();
      return await fixturesapi.getData(
        selectedLeagueId: widget.leagueId,
      );
    } catch (e) {
      throw Exception("Failed to load fixtures: $e");
    }
  }

  Future<List<StandingModel>> getStandings() async {
    try {
      Standing leagueService = Standing();
      return await leagueService.getForSelected(
        selectedLeague: widget.leagueId,
        selectedSeason: 2024,
      );
    } catch (e) {
      throw Exception("Failed to load standings: $e");
    }
  }

  Future<List<TopscoreModel>> getTopScore() async {
    try {
      Topscoreapi topScoreService = Topscoreapi();
      return await topScoreService.getForSelected(
        selectedSeason: 2024,
        selectedSLeague: widget.leagueId,
      );
    } catch (e) {
      throw Exception("Failed to load standings: $e");
    }
  }

  String convertToWITA(String? utcDate) {
    if (utcDate == null) return 'Unknown Date';
    try {
      DateTime utcTime = DateTime.parse(utcDate).toUtc();
      DateTime witaTime = utcTime.add(const Duration(hours: 8));
      return DateFormat('yyyy-MM-dd HH:mm').format(witaTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Competition'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: Colors.white,
            size: 50,
          ),
          Text(
            widget.region,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: DefaultTabController(
              initialIndex: 0,
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Color(0xff1732bb),
                    indicatorColor: Color(0xff1732bb),
                    tabs: <Widget>[
                      Tab(text: "Fixture"),
                      Tab(text: "Standings"),
                      Tab(text: "Top Scorers"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FutureBuilder<List<SoccerMatch>>(
                          future: soccermatch,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No fixtures available.'));
                            } else {
                              List<SoccerMatch> matches = snapshot.data!;
                              matches.sort((a, b) {
                                DateTime dateA = a.fixture?.date != null
                                    ? DateTime.parse(
                                        a.fixture!.date!.toString())
                                    : DateTime(2100, 1, 1);
                                DateTime dateB = b.fixture?.date != null
                                    ? DateTime.parse(
                                        b.fixture!.date!.toString())
                                    : DateTime(2100, 1, 1);
                                return dateA.compareTo(dateB);
                              });

                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final match = snapshot.data![index];
                                  return Card(
                                    color: Colors.grey[900],
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Home Team
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (match.home?.logoUrl != null)
                                                  Image.network(
                                                    match.home!.logoUrl!,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.contain,
                                                  ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  match.home?.name ?? '-',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Match Info
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'vs',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  convertToWITA(match
                                                      .fixture?.date
                                                      .toString()),
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Away Team
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (match.away?.logoUrl != null)
                                                  Image.network(
                                                    match.away!.logoUrl!,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.contain,
                                                  ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  match.away?.name ?? '-',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                        //tandings Tab
                        FutureBuilder<List<StandingModel>>(
                          future: standings,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error: ${snapshot.error}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No standings available.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            final standingsData = snapshot.data!;
                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.black,
                                  child: DataTable(
                                    dividerThickness:
                                        1, // Menambahkan garis antar baris
                                    columns: const [
                                      DataColumn(
                                        label: Text("Rank",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      DataColumn(
                                        label: Text("Team",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      DataColumn(
                                        label: Text("Points",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      DataColumn(
                                        label: Text("Played",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      DataColumn(
                                        label: Text("Wins",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      DataColumn(
                                        label: Text("Draws",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      DataColumn(
                                        label: Text("Loses",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                    rows: standingsData.map((standing) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(
                                            standing.rank?.toString() ?? "-",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                          DataCell(
                                            Row(
                                              children: [
                                                if (standing.team?.logo != null)
                                                  Image.network(
                                                    standing.team!.logo!,
                                                    width: 20, // Ukuran logo
                                                    height: 20,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                  ),
                                                const SizedBox(
                                                    width:
                                                        8), // Jarak antara logo dan nama
                                                Text(
                                                  standing.team?.name ?? "-",
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(Text(
                                            standing.points?.toString() ?? "-",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                          DataCell(Text(
                                            standing.all?.played?.toString() ??
                                                "-",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                          DataCell(Text(
                                            standing.all?.win?.toString() ??
                                                "-",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                          DataCell(Text(
                                            standing.all?.draw?.toString() ??
                                                "-",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                          DataCell(Text(
                                            standing.all?.lose?.toString() ??
                                                "-",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Top Scorers Tab
                        FutureBuilder<List<TopscoreModel>>(
                          future: topscore,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No top scorers available.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            final topscorers = snapshot.data!;
                            return ListView.builder(
                              itemCount: topscorers.length,
                              itemBuilder: (context, index) {
                                final scorer = topscorers[index];
                                return ListTile(
                                  // Gambar pemain di kiri
                                  leading: CircleAvatar(
                                    backgroundImage: scorer.player?.photo !=
                                            null
                                        ? NetworkImage(scorer.player!
                                            .photo!) // Gambar pemain dari URL
                                        : null,
                                    backgroundColor: Colors
                                        .grey, // Background jika gambar tidak ada
                                    child: scorer.player?.photo == null
                                        ? Text(
                                            '${index + 1}', // Nomor urut jika tidak ada foto
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )
                                        : null,
                                  ),
                                  // Nama pemain dan nama tim
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scorer.player?.name ??
                                            'Unknown Player', // Nama pemain
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        scorer.statistics?.isNotEmpty == true
                                            ? scorer.statistics![0].team
                                                    ?.name ??
                                                'Unknown Team'
                                            : 'Unknown Team', // Nama tim
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  // Jumlah gol di kanan
                                  trailing: Text(
                                    '${scorer.statistics?.isNotEmpty == true ? scorer.statistics![0].goals?.total ?? 0 : 0}', // Jumlah gol
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
