import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventName;

  EventDetailsScreen({required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(eventName)),
      body: Center(
        child: Text('Details about $eventName', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
