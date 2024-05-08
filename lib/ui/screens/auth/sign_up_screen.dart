import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/auth/auth_vm.dart';
import 'package:instagram/ui/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_txtfield.dart';
import '../../widgets/user_image_picker.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVM signUpScreenVM = Provider.of(context, listen: true);
    signUpScreenVM.isSignUp = true;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: signUpScreenVM.signUpformKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      const Text(
                        "Hossgram",
                        style:
                            TextStyle(fontSize: 50, fontFamily: 'instalogo1'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const UserImagePicker(),
                      const SizedBox(
                        height: 40,
                      ),
                      customTextFField('Enter your username', Icons.man,
                          signUpScreenVM.usernameController, false, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your username";
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters long';
                        }
                        if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                          return 'Username cannot contain special characters';
                        }
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Username cannot contain digits';
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      customTextFField(
                        'Enter your email',
                        Icons.email,
                        signUpScreenVM.emailController,
                        false,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      customTextFField(
                          'Enter your password',
                          Icons.password_sharp,
                          signUpScreenVM.passwordController,
                          true, (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Password must contain at least one lowercase letter';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain at least one digit';
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      customTextFField('Enter your bio', Icons.description,
                          signUpScreenVM.bioController, false, (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bio';
                        }
                        return null;
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      if (signUpScreenVM.isUbload == true)
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      if (signUpScreenVM.error.isNotEmpty)
                        Center(
                          child: Text(
                            signUpScreenVM.error,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      if (signUpScreenVM.isUbload == false)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 30, left: 30),
                          child: TextButton(
                            onPressed: () {
                              signUpScreenVM.authMange(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(
                              signUpScreenVM.isUbload == true
                                  ? "Loading..."
                                  : "Sign up",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Text.rich(
                TextSpan(
                  text: 'Already have ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'an account?',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
