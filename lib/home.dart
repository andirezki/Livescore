import 'package:flutter/material.dart';
import 'package:livescore/screen/accountscreen.dart';
import 'package:livescore/screen/competitionscreen.dart';
import 'package:livescore/screen/homescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Homescreen(),
    const Competitionscreen(),
    const Accountscreen(),
  ];

  void _onbartapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onbartapped,
        backgroundColor: Colors.black87,
        selectedItemColor: const Color(0xff1732bb),
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Competition'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
