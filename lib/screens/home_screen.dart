// import 'package:flutter/material.dart';
// import 'join_community_screen.dart';

// class HomeScreenWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text('Welcome to the Temple Community!', style: TextStyle(fontSize: 24)),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Navigate to the Join Community screen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => JoinCommunityScreen()),
//               );
//             },
//             child: Text('Join a Community'),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class HomeScreenWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Center(
//         child: Text('This is Home Screen', style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Communion'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            EventCard('UniFi Nights', 'Join us for interfaith dialogue and community building.'),
            EventCard('Community Meetup', 'Discuss social causes and offer support.'),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;

  EventCard(this.title, this.description);

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
