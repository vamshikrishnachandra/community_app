// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('User Profile', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 20),
//             Text('Name: John Doe'),
//             Text('Email: johndoe@example.com'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Code to edit profile or log out
//               },
//               child: Text('Edit Profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Profile')),
//       body: Center(
//         child: Text('Your Profile', style: TextStyle(fontSize: 20)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('User Profile Info Here', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
