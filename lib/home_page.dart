import 'package:flutter/material.dart';
import 'event_page.dart';
import 'support_page.dart';
import 'interfaith_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    EventPage(),
    SupportPage(),
    InterfaithPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Communion"),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.support), label: 'Support'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Interfaith'),
        ],
      ),
    );
  }
}
