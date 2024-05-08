import 'package:image_picker/image_picker.dart';

abstract class PostRepo {
  Future<void> addPostToFirestore(String description, XFile postImage,
      String uid, String username, String profImage);
  Future<void> manageLikes(String postId, String uid, List likes);
  Future<void> addComment(
      String postId, String text, String uid, String name, String profilePic);
  Future<void> deletePost(String postId);
}
