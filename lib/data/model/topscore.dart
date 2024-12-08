import 'dart:convert';

class TopscoreModel {
    Player? player;
    List<Statistic>? statistics;

    TopscoreModel({
        this.player,
        this.statistics,
    });

    factory TopscoreModel.fromRawJson(String str) => TopscoreModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory TopscoreModel.fromJson(Map<String, dynamic> json) => TopscoreModel(
        player: json["player"] == null ? null : Player.fromJson(json["player"]),
        statistics: json["statistics"] == null ? [] : List<Statistic>.from(json["statistics"]!.map((x) => Statistic.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "player": player?.toJson(),
        "statistics": statistics == null ? [] : List<dynamic>.from(statistics!.map((x) => x.toJson())),
    };
}

class Player {
    int? id;
    String? name;
    String? firstname;
    String? lastname;
    int? age;
    Birth? birth;
    String? nationality;
    String? height;
    String? weight;
    bool? injured;
    String? photo;

    Player({
        this.id,
        this.name,
        this.firstname,
        this.lastname,
        this.age,
        this.birth,
        this.nationality,
        this.height,
        this.weight,
        this.injured,
        this.photo,
    });

    factory Player.fromRawJson(String str) => Player.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json["id"],
        name: json["name"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        age: json["age"],
        birth: json["birth"] == null ? null : Birth.fromJson(json["birth"]),
        nationality: json["nationality"],
        height: json["height"],
        weight: json["weight"],
        injured: json["injured"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "firstname": firstname,
        "lastname": lastname,
        "age": age,
        "birth": birth?.toJson(),
        "nationality": nationality,
        "height": height,
        "weight": weight,
        "injured": injured,
        "photo": photo,
    };
}

class Birth {
    DateTime? date;
    String? place;
    String? country;

    Birth({
        this.date,
        this.place,
        this.country,
    });

    factory Birth.fromRawJson(String str) => Birth.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Birth.fromJson(Map<String, dynamic> json) => Birth(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        place: json["place"],
        country: json["country"],
    );

    Map<String, dynamic> toJson() => {
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "place": place,
        "country": country,
    };
}

class Statistic {
    Team? team;
    League? league;
    Games? games;
    Substitutes? substitutes;
    Shots? shots;
    Goals? goals;
    Passes? passes;
    Tackles? tackles;
    Duels? duels;
    Dribbles? dribbles;
    Fouls? fouls;
    Cards? cards;
    Penalty? penalty;

    Statistic({
        this.team,
        this.league,
        this.games,
        this.substitutes,
        this.shots,
        this.goals,
        this.passes,
        this.tackles,
        this.duels,
        this.dribbles,
        this.fouls,
        this.cards,
        this.penalty,
    });

    factory Statistic.fromRawJson(String str) => Statistic.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        team: json["team"] == null ? null : Team.fromJson(json["team"]),
        league: json["league"] == null ? null : League.fromJson(json["league"]),
        games: json["games"] == null ? null : Games.fromJson(json["games"]),
        substitutes: json["substitutes"] == null ? null : Substitutes.fromJson(json["substitutes"]),
        shots: json["shots"] == null ? null : Shots.fromJson(json["shots"]),
        goals: json["goals"] == null ? null : Goals.fromJson(json["goals"]),
        passes: json["passes"] == null ? null : Passes.fromJson(json["passes"]),
        tackles: json["tackles"] == null ? null : Tackles.fromJson(json["tackles"]),
        duels: json["duels"] == null ? null : Duels.fromJson(json["duels"]),
        dribbles: json["dribbles"] == null ? null : Dribbles.fromJson(json["dribbles"]),
        fouls: json["fouls"] == null ? null : Fouls.fromJson(json["fouls"]),
        cards: json["cards"] == null ? null : Cards.fromJson(json["cards"]),
        penalty: json["penalty"] == null ? null : Penalty.fromJson(json["penalty"]),
    );

    Map<String, dynamic> toJson() => {
        "team": team?.toJson(),
        "league": league?.toJson(),
        "games": games?.toJson(),
        "substitutes": substitutes?.toJson(),
        "shots": shots?.toJson(),
        "goals": goals?.toJson(),
        "passes": passes?.toJson(),
        "tackles": tackles?.toJson(),
        "duels": duels?.toJson(),
        "dribbles": dribbles?.toJson(),
        "fouls": fouls?.toJson(),
        "cards": cards?.toJson(),
        "penalty": penalty?.toJson(),
    };
}

class Cards {
    int? yellow;
    int? yellowred;
    int? red;

    Cards({
        this.yellow,
        this.yellowred,
        this.red,
    });

    factory Cards.fromRawJson(String str) => Cards.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Cards.fromJson(Map<String, dynamic> json) => Cards(
        yellow: json["yellow"],
        yellowred: json["yellowred"],
        red: json["red"],
    );

    Map<String, dynamic> toJson() => {
        "yellow": yellow,
        "yellowred": yellowred,
        "red": red,
    };
}

class Dribbles {
    int? attempts;
    int? success;
    dynamic past;

    Dribbles({
        this.attempts,
        this.success,
        this.past,
    });

    factory Dribbles.fromRawJson(String str) => Dribbles.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Dribbles.fromJson(Map<String, dynamic> json) => Dribbles(
        attempts: json["attempts"],
        success: json["success"],
        past: json["past"],
    );

    Map<String, dynamic> toJson() => {
        "attempts": attempts,
        "success": success,
        "past": past,
    };
}

class Duels {
    int? total;
    int? won;

    Duels({
        this.total,
        this.won,
    });

    factory Duels.fromRawJson(String str) => Duels.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Duels.fromJson(Map<String, dynamic> json) => Duels(
        total: json["total"],
        won: json["won"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "won": won,
    };
}

class Fouls {
    int? drawn;
    int? committed;

    Fouls({
        this.drawn,
        this.committed,
    });

    factory Fouls.fromRawJson(String str) => Fouls.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Fouls.fromJson(Map<String, dynamic> json) => Fouls(
        drawn: json["drawn"],
        committed: json["committed"],
    );

    Map<String, dynamic> toJson() => {
        "drawn": drawn,
        "committed": committed,
    };
}

class Games {
    int? appearences;
    int? lineups;
    int? minutes;
    dynamic number;
    String? position;
    String? rating;
    bool? captain;

    Games({
        this.appearences,
        this.lineups,
        this.minutes,
        this.number,
        this.position,
        this.rating,
        this.captain,
    });

    factory Games.fromRawJson(String str) => Games.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Games.fromJson(Map<String, dynamic> json) => Games(
        appearences: json["appearences"],
        lineups: json["lineups"],
        minutes: json["minutes"],
        number: json["number"],
        position: json["position"],
        rating: json["rating"],
        captain: json["captain"],
    );

    Map<String, dynamic> toJson() => {
        "appearences": appearences,
        "lineups": lineups,
        "minutes": minutes,
        "number": number,
        "position": position,
        "rating": rating,
        "captain": captain,
    };
}

class Goals {
    int? total;
    dynamic conceded;
    int? assists;
    int? saves;

    Goals({
        this.total,
        this.conceded,
        this.assists,
        this.saves,
    });

    factory Goals.fromRawJson(String str) => Goals.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Goals.fromJson(Map<String, dynamic> json) => Goals(
        total: json["total"],
        conceded: json["conceded"],
        assists: json["assists"],
        saves: json["saves"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "conceded": conceded,
        "assists": assists,
        "saves": saves,
    };
}

class League {
    int? id;
    String? name;
    String? country;
    String? logo;
    String? flag;
    int? season;

    League({
        this.id,
        this.name,
        this.country,
        this.logo,
        this.flag,
        this.season,
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
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "logo": logo,
        "flag": flag,
        "season": season,
    };
}

class Passes {
    int? total;
    int? key;
    int? accuracy;

    Passes({
        this.total,
        this.key,
        this.accuracy,
    });

    factory Passes.fromRawJson(String str) => Passes.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Passes.fromJson(Map<String, dynamic> json) => Passes(
        total: json["total"],
        key: json["key"],
        accuracy: json["accuracy"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "key": key,
        "accuracy": accuracy,
    };
}

class Penalty {
    int? won;
    dynamic commited;
    int? scored;
    int? missed;
    dynamic saved;

    Penalty({
        this.won,
        this.commited,
        this.scored,
        this.missed,
        this.saved,
    });

    factory Penalty.fromRawJson(String str) => Penalty.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Penalty.fromJson(Map<String, dynamic> json) => Penalty(
        won: json["won"],
        commited: json["commited"],
        scored: json["scored"],
        missed: json["missed"],
        saved: json["saved"],
    );

    Map<String, dynamic> toJson() => {
        "won": won,
        "commited": commited,
        "scored": scored,
        "missed": missed,
        "saved": saved,
    };
}

class Shots {
    int? total;
    int? on;

    Shots({
        this.total,
        this.on,
    });

    factory Shots.fromRawJson(String str) => Shots.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Shots.fromJson(Map<String, dynamic> json) => Shots(
        total: json["total"],
        on: json["on"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "on": on,
    };
}

class Substitutes {
    int? substitutesIn;
    int? out;
    int? bench;

    Substitutes({
        this.substitutesIn,
        this.out,
        this.bench,
    });

    factory Substitutes.fromRawJson(String str) => Substitutes.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Substitutes.fromJson(Map<String, dynamic> json) => Substitutes(
        substitutesIn: json["in"],
        out: json["out"],
        bench: json["bench"],
    );

    Map<String, dynamic> toJson() => {
        "in": substitutesIn,
        "out": out,
        "bench": bench,
    };
}

class Tackles {
    int? total;
    int? blocks;
    int? interceptions;

    Tackles({
        this.total,
        this.blocks,
        this.interceptions,
    });

    factory Tackles.fromRawJson(String str) => Tackles.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Tackles.fromJson(Map<String, dynamic> json) => Tackles(
        total: json["total"],
        blocks: json["blocks"],
        interceptions: json["interceptions"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "blocks": blocks,
        "interceptions": interceptions,
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
