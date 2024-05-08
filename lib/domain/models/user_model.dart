import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String imageUrl;
  String email;
  String name;
  String bio;
  List followers;
  List follwing;

  UserModel(
      {required this.id,
      required this.imageUrl,
      required this.email,
      required this.name,
      required this.bio,
      required this.followers,
      required this.follwing});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
        id: doc['user_id'],
        imageUrl: doc['url_image'],
        email: doc['user_gmail'],
        name: doc['user_name'],
        bio: doc['user_bio'],
        followers: doc['user_followers'],
        follwing: doc['user_following']);
  }
}
