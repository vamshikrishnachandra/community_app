import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding

class InterfaithPage extends StatefulWidget {
  @override
  _InterfaithPageState createState() => _InterfaithPageState();
}

class _InterfaithPageState extends State<InterfaithPage> {
  List<Map<String, String>> resources = [];

  @override
  void initState() {
    super.initState();
    _loadResources(); // Load resources on initialization
  }

  void _loadResources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedResources = prefs.getString('resources');
    
    if (savedResources != null) {
      // Decode the saved JSON string into a List
      List<dynamic> decodedResources = json.decode(savedResources);
      resources = List<Map<String, String>>.from(
          decodedResources.map((item) => Map<String, String>.from(item)));
      setState(() {}); // Update the UI
    }
  }

  void _addResource(String title, String description, String link) async {
    setState(() {
      resources.add({
        'title': title,
        'description': description,
        'link': link,
      });
    });
    await _saveResources(); // Save resources after adding
  }

  Future<void> _saveResources() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedResources = json.encode(resources);
    await prefs.setString('resources', encodedResources);
  }

  void _showAddResourceDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final linkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Resource"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: linkController,
                decoration: InputDecoration(labelText: "Link"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    linkController.text.isNotEmpty) {
                  _addResource(
                    titleController.text,
                    descriptionController.text,
                    linkController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interfaith Dialogue",style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interfaith Resources",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  return ResourceCard(
                    title: resources[index]['title']!,
                    description: resources[index]['description']!,
                    link: resources[index]['link']!,
                    launchURL: _launchURL, // Pass the launch function
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddResourceDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        tooltip: "Add Resource",
      ),
    );
  }
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final Future<void> Function(String url) launchURL;

  const ResourceCard({
    required this.title,
    required this.description,
    required this.link,
    required this.launchURL,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => launchURL(link), // Launch the URL when clicked
              child: Text("View More"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color
                foregroundColor: const Color.fromARGB(255, 239, 232, 232), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
