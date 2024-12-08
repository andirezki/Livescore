import 'package:livescore/data/model/fixtures.dart';

class Scorer {
  Fixture? fixture;
  Time? time;
  Player? player;
  Assist? assist;
  Type? type;
  Detail? detail;
    Team? team;
  

  Scorer(this.fixture, this.time, this.player, this.assist, this.type,
      this.detail, this.team);

  factory Scorer.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("Received null data when expecting a Map");
    }

    return Scorer(
      json['fixture'] != null ? Fixture.fromJson(json['fixture']) : null,
      json['time'] != null ? Time.fromJson(json['time']) : null,
      json['player'] != null ? Player.fromJson(json['player']) : null,
      json['assist'] != null ? Assist.fromJson(json['assist']) : null,
      json['type'] != null ? Type(json['type']) : Type('Unknown'),
      json['detail'] != null ? Detail(json['detail']) : Detail('No details'),
      json['team'] != null ? Team.fromJson(json['team']) : null,
    );
  }
}

class Time {
  int? elapsedTime;
  String? long;
  int? extra; 
  Time(this.elapsedTime, this.long, [this.extra]);

  factory Time.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("Received null data when expecting a Map");
    }
    return Time(json['elapsed'], json['long'], json['extra']);
  }
}

class Player {
  int? id;
  String? name;
  Player(this.id, this.name);

  factory Player.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Player(
          null, null); // Jika json null, buat player dengan nilai null
    }
    return Player(json['id'], json['name']);
  }
}

class Assist {
  int? id;
  String? name;
  Assist(this.id, this.name);

  factory Assist.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Assist(
          null, null); // Jika json null, buat assist dengan nilai null
    }
    return Assist(json['id'], json['name']);
  }
}

class Type {
  String? type;
  Type(this.type);

  factory Type.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("Received null data when expecting a Map");
    }
    return Type(json['type']);
  }
}

class Detail {
  String? detail;
  Detail(this.detail);

  factory Detail.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw Exception("Received null data when expecting a Map");
    }
    return Detail(json['detail']);
  }
}

class Team {
  int? id;
  String? name;
  
  Team(this.id, this.name);

  factory Team.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Team(null, null);
    }
    return Team(json['id'], json['name']);
  }
}