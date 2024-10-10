// import 'package:flutter/material.dart';

// class SupportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Support')),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Request Childcare'),
//             subtitle: Text('Need help with childcare on October 12'),
//           ),
//           ListTile(
//             title: Text('Offer Meal Delivery'),
//             subtitle: Text('Offering meals on October 14'),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Code to create a new support request
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add Support Request',
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class SupportScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Support')),
//       body: Center(
//         child: Text('How can we help you?', style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Offer or Request Support',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SupportOption('Request Childcare', Icons.child_friendly),
            SupportOption('Offer Meals', Icons.restaurant),
          ],
        ),
      ),
    );
  }
}

class SupportOption extends StatelessWidget {
  final String text;
  final IconData icon;

  SupportOption(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(text),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
