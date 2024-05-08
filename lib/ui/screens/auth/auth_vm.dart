import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/data/reposotries/auth_repo_impl.dart';

import '../../../domain/reposotries/auth_repo.dart';
import '../main_screen/home_sreen.dart';

class AuthVM extends ChangeNotifier {
  late GlobalKey<FormState> _formKeylog;
  late GlobalKey<FormState> _formKeysign;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController bioController;
  bool isUbload = false;
  bool isSignUp = false;
  String error = '';
  XFile? selectedImage;
  AuthRepo repo = AuthRepoImpl();

  AuthVM() {
    _formKeylog = GlobalKey<FormState>();
    _formKeysign = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    bioController = TextEditingController();
  }

  GlobalKey<FormState> get loginformKey => _formKeylog;
  GlobalKey<FormState> get signUpformKey => _formKeysign;

  void authMange(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username = usernameController.text;
    String bio = bioController.text;
    isUbload = true;
    notifyListeners();

    if (
        (loginformKey.currentState != null && loginformKey.currentState!.validate()) || 
        (signUpformKey.currentState != null && signUpformKey.currentState!.validate()) ||
        (isSignUp && selectedImage == null)) {
      try {
        if (isSignUp) {
          print('We are in sign up');
          await repo.createUserWithEmailAndPassword(
              email, password, selectedImage!, username, bio);
        } else {
          print('We are in sign in');
          await repo.signInWithEmailAndPassword(email, password);
        }
      } catch (e) {
        error = e.toString();
        print(e.toString());
      }

      isUbload = false;
      notifyListeners();

      if (!isUbload) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainScreen()));
      }
    }
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
    bioController.clear();
    selectedImage = null;
  }

  Future imageFromGallery() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      selectedImage = image;
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
      selectedImage = image;
      notifyListeners();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
