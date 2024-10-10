import 'package:flutter/material.dart';

class NetworkingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interfaith Networking'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          NetworkingEventCard('UniFi Nights', 'Meet with leaders from various faiths.'),
          NetworkingEventCard('Collaborative Projects', 'Join interfaith initiatives.'),
        ],
      ),
    );
  }
}

class NetworkingEventCard extends StatelessWidget {
  final String title;
  final String description;

  NetworkingEventCard(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }
}
