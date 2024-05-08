import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/firebase_firestore/user_database.dart';
import '../../../data/reposotries/post_repo_impl.dart';
import '../../../domain/reposotries/post_repo.dart';

class AddPostTabVm extends ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  var captionController = TextEditingController();
  bool isUbload = false;
  String error = '';
  XFile? selectedPostImage;
  PostRepo repo = PostRepoImpl();

  void addPost(uid, username, profImage) {
    String caption = captionController.text;
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      try {
        isUbload = true;
        repo.addPostToFirestore(
            caption, selectedPostImage!, uid, username, profImage);
        notifyListeners();
      } catch (e) {
        error = e.toString();
        print(error);
        notifyListeners();
      }
      isUbload = false;
      notifyListeners();
    }
    clearPost();
  }

  void clearPost() {
    captionController.clear();
    selectedPostImage = null;
    notifyListeners();
  }

  Future imageFromGallery() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      selectedPostImage = image;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future imageFromCamera() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      selectedPostImage = image;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Stream<DocumentSnapshot> getUserData() {
    return DatabaseOfUser.getDataUser().asStream();
  }
}