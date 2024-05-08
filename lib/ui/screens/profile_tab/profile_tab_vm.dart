import 'package:flutter/material.dart';
import 'package:instagram/data/reposotries/auth_repo_impl.dart';
import 'package:instagram/data/reposotries/profile_repo_impl.dart';
import 'package:instagram/domain/reposotries/auth_repo.dart';
import 'package:instagram/domain/reposotries/profile_repo.dart';

class ProfileTabVM extends ChangeNotifier {
  bool isFollowing = false;
  String error = '';
  ProfileRepo repo = ProfileRepoImpl();
  AuthRepo authRepo = AuthRepoImpl();

manageUNFollow(String followId, String uid) async {
  try {
    bool success = await repo.followUser(followId, uid); // Swap the arguments
    if (success) {
      isFollowing = false;
    } else {
      error = 'Failed to unfollow user.';
    }
  } catch (e) {
    error = e.toString();
  }
  notifyListeners();
}

manageFollow(String followId, String uid) async {
  try {
    bool success = await repo.followUser(followId, uid); // Swap the arguments
    if (success) {
      isFollowing = true;
    } else {
      error = 'Failed to follow user.';
    }
  } catch (e) {
    error = e.toString();
  }
  notifyListeners();
}

  void signOut() {
    authRepo.signOut();
  }
}
