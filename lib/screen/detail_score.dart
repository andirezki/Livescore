import 'package:flutter/material.dart';
import 'package:livescore/data/api/scoreer.dart';
import 'package:livescore/data/api/standingApi.dart';
import 'package:livescore/data/api/head2head.dart';
import 'package:livescore/data/model/fixtures.dart';
import 'package:livescore/data/model/head2head.dart';
import 'package:livescore/data/model/matches.dart';
import 'package:livescore/data/model/standing.dart';

class DetailScore extends StatefulWidget {
  final SoccerMatch match;
  final int fixtureId;
  final int leagueId;
  final int seasonId;
  final int homeId;
  final int awayId;

  const DetailScore({
    super.key,
    required this.match,
    required this.fixtureId,
    required this.leagueId,
    required this.seasonId,
    required this.homeId,
    required this.awayId,
  });

  @override
  State<DetailScore> createState() => DetailScoreState();
}

class DetailScoreState extends State<DetailScore> {
  late Future<List<Scorer>> scorers;
  late Future<List<StandingModel>> standings;
  late Future<List<Head2Head>> head2head;

  bool isHomeTeam(Scorer event) {
    return event.team?.id == widget.homeId;
  }

  @override
  void initState() {
    super.initState();
    scorers = getScorers();
    standings = getStandings();
    head2head = getHead2head();
  }

  Future<List<Scorer>> getScorers() async {
    try {
      ScorerService scorerService = ScorerService();
      return await scorerService.getForSelected(
        selectedFixtureId: widget.fixtureId,
      );
    } catch (e) {
      throw Exception("Failed to load scorers: $e");
    }
  }

  Future<List<StandingModel>> getStandings() async {
    try {
      Standing leagueService = Standing();
      return await leagueService.getForSelected(
        selectedLeague: widget.leagueId,
        selectedSeason: widget.seasonId,
      );
    } catch (e) {
      throw Exception("Failed to load standings: $e");
    }
  }

  Future<List<Head2Head>> getHead2head() async {
    try {
      HeadtoHead head2headService = HeadtoHead();
      return await head2headService.getData(
        selectedHomeId: widget.homeId,
        selectedAwayId: widget.awayId,
        last: 5,
      );
    } catch (e) {
      throw Exception("Failed to load head-to-head data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: const Text(
            "Match Detail",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xff1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            match.home?.logoUrl != null
                                ? Image.network(
                                    match.home!.logoUrl!,
                                    width: 50,
                                    height: 50,
                                  )
                                : const Icon(Icons.sports_soccer),
                            Text(
                              match.home?.name ?? 'Home Team',
                              style: const TextStyle(color: Colors.white),
                              maxLines: 2,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${match.goal?.home ?? 0} - ${match.goal?.away ?? 0}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              match.fixture?.date != null
                                  ? "${match.fixture?.date}"
                                  : "Date not available",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 1),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            match.away?.logoUrl != null
                                ? Image.network(
                                    match.away!.logoUrl!,
                                    width: 50,
                                    height: 50,
                                  )
                                : const Icon(Icons.sports_soccer),
                            Text(
                              match.away?.name ?? 'Away Team',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const TabBar(
                labelColor: Color(0xff1732bb),
                indicatorColor: Color(0xff1732bb),
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(text: "Events"),
                  Tab(text: "Standings"),
                  Tab(text: "Head 2 head"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Events Tab
                    FutureBuilder<List<Scorer>>(
                      future: scorers,
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
                              "No events available.",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final events = snapshot.data!;
                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            final isHome = isHomeTeam(event);

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: index < events.length - 1
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // Home team events - left side
                                  Expanded(
                                    flex: 4,
                                    child: isHome
                                        ? _buildEventDetails(event)
                                        : const SizedBox.shrink(),
                                  ),
                                  // Time column - middle
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        "${event.time?.elapsedTime}'",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Away team events - right side
                                  Expanded(
                                    flex: 4,
                                    child: !isHome
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: _buildEventDetails(event),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

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
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  DataColumn(
                                    label: Text("Team",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  DataColumn(
                                    label: Text("Points",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  DataColumn(
                                    label: Text("Played",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  DataColumn(
                                    label: Text("Wins",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  DataColumn(
                                    label: Text("Draws",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  DataColumn(
                                    label: Text("Loses",
                                        style: TextStyle(color: Colors.white)),
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
                                                errorBuilder: (context, error,
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
                                        standing.all?.played?.toString() ?? "-",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        standing.all?.win?.toString() ?? "-",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        standing.all?.draw?.toString() ?? "-",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )),
                                      DataCell(Text(
                                        standing.all?.lose?.toString() ?? "-",
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

                    // Head to Head Tab
                    FutureBuilder<List<Head2Head>>(
                      future: head2head,
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
                              "No head-to-head data available.",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        // print('test $head2head');

                        final head2headData = snapshot.data!;
                        // print(snapshot.data);
                        return ListView.builder(
                          itemCount: head2headData.length,
                          itemBuilder: (context, index) {
                            final data = head2headData[index];
                            return Card(
                              color: const Color(0xff1E1E1E),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Tim Home
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            data.teams.home.logo,
                                            width: 40,
                                            height: 40,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(Icons.sports_soccer,
                                                    color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            data.teams.home.name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Skor
                                    Text(
                                      "${data.goals.home} - ${data.goals.away}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // Tim Away
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            data.teams.away.logo,
                                            width: 40,
                                            height: 40,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                const Icon(Icons.sports_soccer,
                                                    color: Colors.white),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            data.teams.away.name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                            textAlign: TextAlign.center,
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
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventDetails(Scorer event) {
    return Column(
      crossAxisAlignment:
          isHomeTeam(event) ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          event.player?.name ?? "Unknown Player",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Text(
          event.detail?.detail ?? "Normal Goal",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        if (event.assist?.name != null)
          Text(
            "Assist: ${event.assist?.name}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}
