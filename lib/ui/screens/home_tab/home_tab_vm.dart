import 'package:flutter/material.dart';

import '../../../data/reposotries/post_repo_impl.dart';
import '../../../domain/reposotries/post_repo.dart';

class HomeTabVM extends ChangeNotifier {
  String error = '';
  bool isChoiced = false;
  PostRepo repo = PostRepoImpl();

  deletePost(postId) {
    repo.deletePost(postId);
  }

  void chamgeChoice() {
    isChoiced = !isChoiced;
    notifyListeners();
  }

  void manageLikes(postId, uid, likes) {
    try {
      repo.manageLikes(postId, uid, likes);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
