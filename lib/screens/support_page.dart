import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SupportScreen extends StatelessWidget {
  Future<String?> _getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId'); // Get the userId from shared prefs
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserId(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No user ID found.'));
        } else {
          String currentUserId = snapshot.data!; // Get the current user ID

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Help & Support',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.deepPurple,
            ),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help Requests',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('help_requests').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Text('No help requests found.');
                        }

                        return Column(
                          children: snapshot.data!.docs.map((doc) {
                            String title = doc['helpType'];
                            String status = doc['status'];
                            String requesterId = doc['requesterId']; // Get the requester ID

                            // Check if the current user is the requester
                            bool isRequester = currentUserId == requesterId;
                            bool isFulfilled = status == 'Fulfilled';

                            // Show the request only if it's not fulfilled for non-requesters
                            if (!isRequester && isFulfilled) return SizedBox.shrink();

                            return HelpRequestItem(
                              title: title,
                              status: status,
                              isRequester: isRequester, // Pass isRequester to HelpRequestItem
                              onFulfill: () {
                                // Implement fulfillment logic here, e.g., update Firestore
                                _fulfillHelpRequest(doc.id);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Help request fulfilled!'),
                                ));
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Frequently Asked Questions (FAQs)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    FAQItem(
                      question: 'How can I request childcare?',
                      answer: 'You can request childcare by contacting our support team.',
                    ),
                    FAQItem(
                      question: 'How do I offer meal delivery?',
                      answer: 'To offer meal delivery, please fill out the form on our website.',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Additional Resources',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _contactSupport(context);
                      },
                      child: Text(
                        'Contact Support',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        _launchURL('https://persistventures.com'); // Change to your actual URL
                      },
                      child: Text(
                        'Visit Persist Ventures Website',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showNewSupportRequestPage(context);
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.deepPurple,
            ),
          );
        }
      },
    );
  }

  void _contactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Support'),
          content: Text('Support contact options coming soon!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showNewSupportRequestPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewSupportRequestPage()),
    );
  }

  Future<void> _fulfillHelpRequest(String requestId) async {
    try {
      // Update the Firestore document to mark the request as fulfilled
      await FirebaseFirestore.instance.collection('help_requests').doc(requestId).update({
        'status': 'Fulfilled', // Update the status
      });
    } catch (e) {
      // Handle errors
      print('Error fulfilling request: $e');
    }
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(question),
        subtitle: Text(answer),
      ),
    );
  }
}

class HelpRequestItem extends StatelessWidget {
  final String title;
  final String status;
  final bool isRequester; // Add isRequester parameter
  final VoidCallback onFulfill;

  HelpRequestItem({required this.title, required this.status, required this.isRequester, required this.onFulfill});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(title),
        subtitle: isRequester ? Text('Status: $status') : null, // Show status only for the requester
        trailing: isRequester
            ? null // Don't show fulfill button for the requester
            : TextButton(
                onPressed: onFulfill,
                child: Text('Fulfill'),
              ),
      ),
    );
  }
}

class NewSupportRequestPage extends StatefulWidget {
  @override
  _NewSupportRequestPageState createState() => _NewSupportRequestPageState();
}

class _NewSupportRequestPageState extends State<NewSupportRequestPage> {
  final TextEditingController _helpTypeController = TextEditingController();

  @override
  void dispose() {
    _helpTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('New Support Request', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help Type:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _helpTypeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Help Type',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitHelpRequest(); // Call the submit function
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitHelpRequest() async {
    String helpType = _helpTypeController.text.trim();
    String? userId = await _getUserId(); // Retrieve the user ID from shared preferences

    if (helpType.isNotEmpty && userId != null) {
      try {
        // Add a new document to the 'help_requests' collection
        await FirebaseFirestore.instance.collection('help_requests').add({
          'helpType': helpType,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'Pending', // You can set initial status as 'Pending'
          'requesterId': userId, // Save the user ID as requester ID
        });

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Help request submitted successfully!'),
        ));
        Navigator.pop(context);
      } catch (e) {
        // Handle errors
        print('Error submitting request: $e');
      }
    } else {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid help type.'),
      ));
    }
  }

  Future<String?> _getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userId');
  }
}

