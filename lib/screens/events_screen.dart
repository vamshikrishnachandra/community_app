import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:temple_community_app/screens/events/event_detail_page.dart';
import 'events/create_event_page.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If we have data, display it in a ListView
          final events = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventCard(
                eventid: event.id,  // Use the document ID from Firestore
                title: event['title'],
                description: event['description'],
                imageUrl: event['imageUrl'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEventPage(
                        eventId: event.id, // Pass the document ID
                        title: event['title'],
                        description: event['description'],
                        imageUrl: event['imageUrl'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEventPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final VoidCallback? onTap;
  final String eventid;

  EventCard({
    required this.title,
    required this.description,
    this.imageUrl,
    this.onTap,
    required this.eventid, // Event ID is required here
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder image URL in case no image is provided
    const String placeholderImageUrl =
        'https://user-images.githubusercontent.com/2351721/31314483-7611c488-ac0e-11e7-97d1-3cfc1c79610e.png';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(
              eventId: eventid,  // Pass the event ID to the details page
              title: title,
              description: description,
              imageUrl: imageUrl ?? placeholderImageUrl,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Image.network(
                imageUrl?.isNotEmpty == true ? imageUrl! : placeholderImageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  placeholderImageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
