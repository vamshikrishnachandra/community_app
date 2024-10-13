import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import for Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateEventPage extends StatefulWidget {
  final String? eventId; // To hold the ID of the event being edited
  final String? title;
  final String? description;
  final String? imageUrl;

  CreateEventPage({this.eventId, this.title, this.description, this.imageUrl});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  File? _selectedImage; // For image upload
  bool _isUploading = false; // To show upload progress
  String? _uploadedImageUrl; // To store uploaded image URL

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  // Function to pick image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to upload image to Firebase Storage and return the download URL
  Future<String?> _uploadImage(File image) async {
    try {
      setState(() {
        _isUploading = true;
      });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('events/$fileName');
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to create or update event
  Future<void> _saveEvent() async {
    String? imageUrl;

    // Check if an image is selected and upload it if needed
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!);
      if (imageUrl == null) {
        // Show error if image upload fails
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image upload failed. Please try again.'),
        ));
        return;
      }
    } else {
      imageUrl = widget.imageUrl; // Use existing image URL if no new image is selected
    }

    // Save the event to Firestore
    if (widget.eventId == null) {
      // Create a new event
      await FirebaseFirestore.instance.collection('events').add({
        'title': titleController.text,
        'description': descriptionController.text,
        'imageUrl': imageUrl,
      });
    } else {
      // Update the existing event
      await FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
        'title': titleController.text,
        'description': descriptionController.text,
        'imageUrl': imageUrl,
      });
    }

    Navigator.pop(context, 'Event updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventId == null ? 'Create Event' : 'Edit Event'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Description Field
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Event Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Image Upload Section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : widget.imageUrl != null
                        ? Image.network(widget.imageUrl!, fit: BoxFit.cover)
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 50, color: Colors.grey),
                                Text('Tap to upload an image'),
                              ],
                            ),
                          ),
              ),
            ),
            SizedBox(height: 20),
            // Save or Create Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _saveEvent, // Disable button during upload
                child: _isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(widget.eventId == null ? 'Create Event' : 'Save Changes',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
