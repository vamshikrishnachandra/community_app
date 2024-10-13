class UserProfile {
  String uid;
  String name;
  String email;
  String phone;
  String religion;
  String address;
  String? photoUrl; // Optional field for profile photo URL

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.religion,
    required this.address,
    this.photoUrl,
  });

  // Convert Firestore document to UserProfile model
  factory UserProfile.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      religion: data['religion'] ?? '',
      address: data['address'] ?? '',
      photoUrl: data['photoUrl'], // Optional
    );
  }

  // Convert UserProfile model to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'religion': religion,
      'address': address,
      'photoUrl': photoUrl,
    };
  }
}
