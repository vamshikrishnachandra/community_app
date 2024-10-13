import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String? _currentUserId;
  List<dynamic> _connectedUsers = []; // Store the list of connected user IDs

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  // Fetch the current user ID and their connections
  Future<void> _getCurrentUserId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _currentUserId = currentUser.uid;
      });
      // Fetch the current user's connections from Firestore
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(_currentUserId)
          .get();
      setState(() {
        _connectedUsers = userProfile['connections'] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connections",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search users...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = "";
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: _currentUserId == null
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('profiles').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final users = snapshot.data!.docs.where((user) {
                        final name = user['name'].toLowerCase();
                        return user.id != _currentUserId && name.contains(_searchQuery);
                      }).toList();

                      if (users.isEmpty) {
                        return Center(child: Text("No users found"));
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final userId = users[index].id;
                          final isConnected = _connectedUsers.contains(userId);

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            elevation: 2,
                            child: ListTile(
                              title: Text(users[index]['name']),
                              subtitle: Text(users[index]['religion']),
                              trailing: isConnected
                                  ? Text(
                                      'Connected',
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        _connectUser(userId); // Pass the friend's user ID
                                      },
                                      child: Text("Connect"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Connect with the user and store in Firestore profile 'connections' field
  void _connectUser(String friendUserId) async {
    if (_currentUserId == null) return;

    try {
      // Add the friend's user ID to the current user's connections list
      await FirebaseFirestore.instance.collection('profiles').doc(_currentUserId).update({
        'connections': FieldValue.arrayUnion([friendUserId]),
      });

      // Add the current user ID to the friend's connections list (optional, for mutual connection)
      await FirebaseFirestore.instance.collection('profiles').doc(friendUserId).update({
        'connections': FieldValue.arrayUnion([_currentUserId]),
      });

      setState(() {
        _connectedUsers.add(friendUserId); // Update the UI with the new connection
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are now connected with user ID: $friendUserId')),
      );
    } catch (e) {
      print('Error connecting with user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect with user')),
      );
    }
  }
}
