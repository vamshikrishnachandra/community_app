import 'dart:io'; // Import File class
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import FirebaseStorage
import 'package:image_picker/image_picker.dart';
import 'package:temple_community_app/screens/home_page.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _photoUrl; // To store the download URL of the photo
  XFile? _imageFile; // To store the locally selected image file

  Future<void> _saveProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Upload image to Firebase Storage (if selected)
      if (_imageFile != null) {
        String fileName = 'profile_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg';
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(File(_imageFile!.path));
        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL after upload
        _photoUrl = await snapshot.ref.getDownloadURL();
      }

      // Save the profile information to Firestore
      await _firestore.collection('profiles').doc(uid).set({
        'name': _nameController.text,
        'email': user.email,  // Email is auto-fetched from FirebaseAuth
        'phone': _phoneController.text,
        'religion': _religionController.text,
        'address': _addressController.text,
        'photoUrl': _photoUrl, // Save the download URL if available
      });
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomePage()),
  (Route<dynamic> route) => false, // Remove all previous routes
);

    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image; // Store the local file for uploading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                child: _imageFile == null ? Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _religionController,
              decoration: InputDecoration(labelText: 'Religion'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
