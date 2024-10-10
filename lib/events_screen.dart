// import 'package:flutter/material.dart';
// import 'event_details_screen.dart';

// class EventsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Events')),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Temple Festival'),
//             subtitle: Text('Date: 2024-10-10'),
//             onTap: () {
//               // Navigate to event details
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => EventDetailsScreen(eventName: 'Temple Festival')),
//               );
//             },
//           ),
//           ListTile(
//             title: Text('Charity Event'),
//             subtitle: Text('Date: 2024-11-15'),
//             onTap: () {
//               // Navigate to event details
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => EventDetailsScreen(eventName: 'Charity Event')),
//               );
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Code to create a new event
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add Event',
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class EventsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Events')),
//       body: Center(
//         child: Text('Upcoming Events', style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          EventCard('UniFi Nights', 'Interfaith dialogue and events.'),
          EventCard('Support Gathering', 'Come together to support your community.'),
        ],
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
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
