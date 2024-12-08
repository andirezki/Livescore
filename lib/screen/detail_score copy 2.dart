// class StandingModel {
//   Standings standings;
//   Team team;
//   All all;
//   Goals goals;

//   StandingModel(this.standings, this.team, this.all, this.goals);

//   factory StandingModel.fromJson(Map<String, dynamic> json) {
//     return StandingModel(
//         Standings.fromJson(json['standing'] ?? {}),
//         Team.fromJson(json['team'] ?? {}),
//         All.fromJson(json['all'] ?? {}),
//         Goals.fromJson(json['goals'] ?? {}));
//   }
// }

// class Standings {
//   int? rank;
//   int? points;
//   int? goalsdiff;

//   Standings(
//     this.rank,
//     this.points,
//     this.goalsdiff,
//   );

//   factory Standings.fromJson(Map<String, dynamic> json) {
//     return Standings(json['rank'], json['points'], json['goalsdiff']);
//   }
// }

// class Team {
//   int? id;
//   String? name;
//   String? logo;

//   Team(
//     this.id,
//     this.name,
//     this.logo,
//   );

//   factory Team.fromJson(Map<String, dynamic> json) {
//     return Team(
//       json['id'],
//       json['name'] != null ? json['name'] : '',
//       json['logo'] != null ? json['logo'] : '',
//     );
//   }
// }

// class All {
//   int? played;
//   int? win;
//   int? draw;
//   int? lose;
//   Goals goals;

//   All(
//     this.played,
//     this.win,
//     this.draw,
//     this.lose,
//     this.goals,
//   );

//   factory All.fromJson(Map<String, dynamic> json) {
//     return All(
//       json['played'],
//       json['win'],
//       json['draw'],
//       json['lose'],
//       Goals.fromJson(json['goals'] ?? {}),
//     );
//   }
// }

// class Goals {
//   int? goalsFor;
//   int? against;

//   Goals(
//     this.goalsFor,
//     this.against,
//   );

//   factory Goals.fromJson(Map<String, dynamic> json) {
//     return Goals(
//       json['for'],
//       json['against'],
//     );
//   }
// }