import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Accountscreen extends StatefulWidget {
  const Accountscreen({super.key});

  @override
  State<Accountscreen> createState() => _AccountscreenState();
}

class _AccountscreenState extends State<Accountscreen> {
  String selectedFilter = 'League';
  String userName = 'Loading...'; // Placeholder for the user's name

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userName = user?.displayName ?? 'User'; // Display name as username
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[800],
                    child:
                        const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Favorites',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildFavoritesInfo(),
            const SizedBox(height: 20),
            const Text(
              'General',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSwitchTile('App Notifications', true),
            _buildDropdownTile('Filter Matches By',
                ['League', 'Cup', 'International'], selectedFilter, (newValue) {
              setState(() {
                selectedFilter = newValue!;
              });
            }),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1732bb),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        color: Color(0xff1E1E1E),
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("teams", style: TextStyle(color: Colors.white)),
                  Text('2', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Text('Competitions', style: TextStyle(color: Colors.white)),
                  Text('4', style: TextStyle(color: Colors.white)),
                ],
              ),
              Column(
                children: [
                  Text('Players', style: TextStyle(color: Colors.white)),
                  Text('8', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool isOn) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Switch(
            value: isOn,
            onChanged: (value) {
              // Handle the switch change
            },
            activeColor: const Color(0xff1732bb),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile(String title, List<String> options,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          DropdownButton<String>(
            value: selectedValue,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.grey)),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: Colors.grey[800],
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
