import 'package:flutter/material.dart';
import 'package:instagram/data/firebase_firestore/user_database.dart';
import 'package:instagram/domain/models/user_model.dart';

import '../../../data/reposotries/post_repo_impl.dart';
import '../../../domain/reposotries/post_repo.dart';

class CommentScreenVM extends ChangeNotifier {
  var formKey = GlobalKey<FormState>();
  var addCommentController = TextEditingController();
  UserModel? _user;
  UserModel get getUser => _user!;
  bool isUbload = false;
  String error = '';
  PostRepo repo = PostRepoImpl();

  CommentScreenVM() {
    getUserData();
  }

  Future<void> getUserData() async {
    isUbload = true;
    notifyListeners();
    try {
      UserModel user = await DatabaseOfUser.getDataOfUser();
      _user = user;
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
    isUbload = false;
    notifyListeners();
  }

  void addComment(String postId, String uid, String name, String profilePic) {
    String text = addCommentController.text;
    try {
      if (text.isNotEmpty) {
        repo.addComment(postId, text, uid, name, profilePic);
        notifyListeners();
      } else {
        error = 'please enter text';
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
    addCommentController.clear();
  }
}
