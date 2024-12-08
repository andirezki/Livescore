import 'dart:convert';

class Head2Head {
    League league;
    Teams teams;
    Goals goals;

    Head2Head({
        required this.league,
        required this.teams,
        required this.goals,
    });

    factory Head2Head.fromRawJson(String str) => Head2Head.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Head2Head.fromJson(Map<String, dynamic> json) => Head2Head(
        league: League.fromJson(json["league"]),
        teams: Teams.fromJson(json["teams"]),
        goals: Goals.fromJson(json["goals"]),
    );

    Map<String, dynamic> toJson() => {
        "league": league.toJson(),
        "teams": teams.toJson(),
        "goals": goals.toJson(),
    };
}

class Goals {
    int home;
    int away;

    Goals({
        required this.home,
        required this.away,
    });

    factory Goals.fromRawJson(String str) => Goals.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        home: json["home"],
        away: json["away"],
    );

    Map<String, dynamic> toJson() => {
        "home": home,
        "away": away,
    };
}

class League {
    int id;
    String name;
    String country;
    String logo;
    String flag;
    int season;
    String round;

    League({
        required this.id,
        required this.name,
        required this.country,
        required this.logo,
        required this.flag,
        required this.season,
        required this.round,
    });

    factory League.fromRawJson(String str) => League.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"],
        name: json["name"],
        country: json["country"],
        logo: json["logo"],
        flag: json["flag"],
        season: json["season"],
        round: json["round"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "logo": logo,
        "flag": flag,
        "season": season,
        "round": round,
    };
}

class Teams {
    Away home;
    Away away;

    Teams({
        required this.home,
        required this.away,
    });

    factory Teams.fromRawJson(String str) => Teams.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Teams.fromJson(Map<String, dynamic> json) => Teams(
        home: Away.fromJson(json["home"]),
        away: Away.fromJson(json["away"]),
    );

    Map<String, dynamic> toJson() => {
        "home": home.toJson(),
        "away": away.toJson(),
    };
}

class Away {
    int id;
    String name;
    String logo;
    bool winner;

    Away({
        required this.id,
        required this.name,
        required this.logo,
        required this.winner,
    });

    factory Away.fromRawJson(String str) => Away.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Away.fromJson(Map<String, dynamic> json) => Away(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        winner: json["winner"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "winner": winner,
    };
}