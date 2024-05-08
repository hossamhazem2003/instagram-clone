import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/data/firebase_firestore/user_database.dart';
import 'package:instagram/domain/reposotries/auth_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/models/user_model.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<void> createUserWithEmailAndPassword(
      email, password, selectedImage, name, bio) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //print(credential.user);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('url_image')
          .child("${credential.user!.uid}.jpg");
      print(selectedImage.path);
      TaskSnapshot uploadTask =
          await storageRef.putFile(File(selectedImage.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();
      print('Step1 done');
      UserModel userModel = UserModel(
          id: credential.user!.uid,
          imageUrl: imageUrl,
          email: email,
          name: name,
          bio: bio,
          followers: [],
          follwing: []);
      print('Step2 done');
      DatabaseOfUser.addDataUser(userModel);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('error is $e');
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(email, password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Done');
      print("User credential sign up: ${credential.user}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  
  @override
  Future<void> signOut() async {
    final _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }
}
