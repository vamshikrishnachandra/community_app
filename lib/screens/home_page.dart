import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'events_screen.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'profile_setup_page.dart';
import 'support_page.dart';
import 'interfaith_page.dart';
import 'connections_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Set the initial index to 0

  // Ensure that the number of pages matches the BottomNavigationBar items.
  final List<Widget> _pages = [
    EventsScreen(),
    SupportScreen(),
    InterfaithPage(),
    ConnectionsPage(), // Added Connections page, total 4 pages now
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Communion"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Logout functionality
          ),
        ],
      ),
      body: Column(
        children: [
          // Title and Description Section
        
          // Main Content Area
          Expanded(
            child: _pages[_currentIndex], // Ensure this accesses valid index
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the index on tap
          });
        },
        // Set icon color customization
        selectedItemColor: Colors.deepPurple, // Color for selected icon
        unselectedItemColor: Colors.grey, // Color for unselected icons
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Interfaith',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact),
            label: 'Connections',
          ),
        ],
      ),
    );
  }
}
