import 'package:flutter/material.dart';
import 'package:instagram/data/firebase_firestore/user_database.dart';
import 'package:instagram/data/reposotries/post_repo_impl.dart';
import 'package:instagram/domain/reposotries/post_repo.dart';

import '../../../domain/models/user_model.dart';

class HomeScreenVM extends ChangeNotifier {
  int selectedIndex = 0;
  var formKey = GlobalKey<FormState>();
  UserModel? _user;
  UserModel get getUser => _user!;
  PostRepo repo = PostRepoImpl();
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  String profileUrl = '';
  bool isFollowing = false;
  bool isLoading = false;

  Future<void> getDataOfUser() async {
    UserModel user = await DatabaseOfUser.getDataOfUser();
    _user = user;
    notifyListeners();
  }

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
