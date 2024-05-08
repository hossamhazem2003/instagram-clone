import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/domain/models/post.dart';
import 'package:instagram/domain/models/user_model.dart';

class DatabaseOfUser {
  static Future<void> addDataUser(UserModel userModel) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'user_id': userModel.id,
          'user_name': userModel.name,
          'user_gmail': userModel.email,
          'url_image': userModel.imageUrl,
          'user_bio': userModel.bio,
          'user_followers': userModel.followers,
          'user_following': userModel.follwing
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<UserModel> getDataOfUser() async{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel(
      id: documentSnapshot['user_id'], 
      imageUrl: documentSnapshot['url_image'], 
      email: documentSnapshot['user_gmail'], 
      name: documentSnapshot['user_name'], 
      bio: documentSnapshot['user_bio'], 
      followers: documentSnapshot['user_followers'], 
      follwing: documentSnapshot['user_following']);
  }

  static Future<DocumentSnapshot> getDataUser() async {
    final getMessageDataFromFirestore = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return getMessageDataFromFirestore;
  }

  static Future<void> addPostToDatabase(Post post, String postId) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return await posts
        .doc(postId)
        .set({
          'description': post.description,
          'uid': post.uid,
          'username': post.username,
          'likes': [],
          'postId': post.postId,
          'datePublished': post.datePublished,
          'postUrl': post.postUrl,
          'profImage': post.profImage,
        })
        .then((value) => print("Post Added"))
        .catchError((error) => print("Failed to add post: $error"));
  }

  static Future<void> addCommentToDatabase(String postId, String text,
      String uid, String name, String profilePic, String commentId) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return await posts
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
          'text': text,
          'uid': uid,
          'name': name,
          'profilePic': profilePic,
          'commentId': commentId,
          'datePublished': DateTime.now()
        })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }

  static Future<DocumentSnapshot> getPostData(postId) async {
    final getPostDataFromFirestore =
        await FirebaseFirestore.instance.collection('posts').doc(postId).get();

    return getPostDataFromFirestore;
  }
}
