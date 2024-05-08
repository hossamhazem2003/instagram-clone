import 'package:image_picker/image_picker.dart';

abstract class AuthRepo {
  Future<void> createUserWithEmailAndPassword(String email, String password,
      XFile selectedImage, String name, String bio);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}
