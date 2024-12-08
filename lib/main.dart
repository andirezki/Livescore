import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'home.dart';
import 'screen/login.dart';
import 'screen/register.dart';
import 'screen/detail_score.dart';
import 'screen/detail_competition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);
  runApp(const LiveScoreApp());
}

class LiveScoreApp extends StatelessWidget {
  const LiveScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/detailCom':
            final args = settings.arguments as Map<String, dynamic>?;

            if (args != null) {
              return MaterialPageRoute(
                builder: (context) => DetailCompetition(
                  title: args['title'] ?? 'Unknown Title',
                  region: args['region'] ?? 'Unknown Region',
                  icon: args['icon'],
                  leagueId: args['league'],
                ),
              );
            }
            return _errorRoute();
          case '/DetailScore':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('match')) {
              return MaterialPageRoute(
                builder: (context) => DetailScore(
                  match: args['match'],
                  fixtureId: args['fixture'],
                  leagueId: args['league'],
                  seasonId: args['season'],
                  homeId: args['home'],
                  awayId: args['away'],
                ),
              );
            }
            return _errorRoute();
          default:
            return null;
        }
      },
      routes: {
        '/register': (context) => RegisterPage(),
        '/homepage': (context) => const HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }

  // Error route for handling unknown or incorrect arguments
  Route _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found or invalid arguments')),
      ),
    );
  }
}