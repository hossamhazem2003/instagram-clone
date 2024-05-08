import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/data/firebase_firestore/user_database.dart';
import 'package:instagram/domain/models/post.dart';
import 'package:instagram/domain/reposotries/post_repo.dart';
import 'package:uuid/uuid.dart';

class PostRepoImpl extends PostRepo {
  @override
  Future<void> addPostToFirestore(
      description, postImage, uid, username, profImage) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      String postId = const Uuid().v1();
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('url_post')
          .child(_auth.currentUser!.uid)
          .child('$postId.jpg');
      TaskSnapshot uploadTask = await storageRef.putFile(File(postImage.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: imageUrl,
          profImage: profImage);
      DatabaseOfUser.addPostToDatabase(post, postId);
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> manageLikes(String postId, String uid, List likes) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    try {
      if (likes.contains(uid)) {
        posts.doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        posts.doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('error in update likes ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addComment(postId, text, uid, name, profilePic) async {
    try {
      String commentId = const Uuid().v1();
      DatabaseOfUser.addCommentToDatabase(
          postId, text, uid, name, profilePic, commentId);
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deletePost(postId) async {
    try {
      return await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
