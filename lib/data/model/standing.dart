import 'dart:convert';

class Standings {
  List<List<StandingModel>>? standings;

  Standings({
    this.standings,
  });

  factory Standings.fromRawJson(String str) =>
      Standings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Standings.fromJson(Map<String, dynamic> json) => Standings(
        standings: json["standings"] == null
            ? null
            : List<List<StandingModel>>.from(json["standings"].map((x) =>
                List<StandingModel>.from(
                    x.map((x) => StandingModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "standings": standings == null
            ? null
            : List<dynamic>.from(standings!
                .map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class StandingModel {
  int? rank;
  Team? team;
  int? points;
  int? goalsDiff;
  String? group;
  String? form;
  String? status;
  String? description;
  All? all;
  All? home;
  All? away;
  DateTime? update;

  StandingModel({
    this.rank,
    this.team,
    this.points,
    this.goalsDiff,
    this.group,
    this.form,
    this.status,
    this.description,
    this.all,
    this.home,
    this.away,
    this.update,
  });

  factory StandingModel.fromRawJson(String str) =>
      StandingModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StandingModel.fromJson(Map<String, dynamic> json) => StandingModel(
        rank: json["rank"],
        team: json["team"] == null ? null : Team.fromJson(json["team"]),
        points: json["points"],
        goalsDiff: json["goalsDiff"],
        group: json["group"],
        form: json["form"],
        status: json["status"],
        description: json["description"],
        all: json["all"] == null ? null : All.fromJson(json["all"]),
        home: json["home"] == null ? null : All.fromJson(json["home"]),
        away: json["away"] == null ? null : All.fromJson(json["away"]),
        update: json["update"] == null ? null : DateTime.parse(json["update"]),
      );

  Map<String, dynamic> toJson() => {
        "rank": rank,
        "team": team?.toJson(),
        "points": points,
        "goalsDiff": goalsDiff,
        "group": group,
        "form": form,
        "status": status,
        "description": description,
        "all": all?.toJson(),
        "home": home?.toJson(),
        "away": away?.toJson(),
        "update": update?.toIso8601String(),
      };
}

class All {
  int? played;
  int? win;
  int? draw;
  int? lose;
  Goals? goals;

  All({
    this.played,
    this.win,
    this.draw,
    this.lose,
    this.goals,
  });

  factory All.fromRawJson(String str) => All.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory All.fromJson(Map<String, dynamic> json) => All(
        played: json["played"],
        win: json["win"],
        draw: json["draw"],
        lose: json["lose"],
        goals: json["goals"] == null ? null : Goals.fromJson(json["goals"]),
      );

  Map<String, dynamic> toJson() => {
        "played": played,
        "win": win,
        "draw": draw,
        "lose": lose,
        "goals": goals?.toJson(),
      };
}

class Goals {
  int? goalsFor;
  int? against;

  Goals({
    this.goalsFor,
    this.against,
  });

  factory Goals.fromRawJson(String str) => Goals.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        goalsFor: json["for"],
        against: json["against"],
      );

  Map<String, dynamic> toJson() => {
        "for": goalsFor,
        "against": against,
      };
}

class Team {
  int? id;
  String? name;
  String? logo;

  Team({
    this.id,
    this.name,
    this.logo,
  });

  factory Team.fromRawJson(String str) => Team.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}
