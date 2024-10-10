import 'package:flutter/material.dart';

class JoinCommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join a Community'),
      ),
      body: Center(
        child: Text(
          'List of Communities to Join',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
