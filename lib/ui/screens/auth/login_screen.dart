import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/auth/auth_vm.dart';
import 'package:instagram/ui/screens/auth/sign_up_screen.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_txtfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthVM loginScreenVM = Provider.of(context, listen: true);
    loginScreenVM.isSignUp = false;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: loginScreenVM.loginformKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Hossgram",
                      style: TextStyle(fontSize: 50, fontFamily: 'instalogo1'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    customTextFField(
                      'Enter your email',
                      Icons.email,
                      loginScreenVM.emailController,
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
                    customTextFField('Enter your password', Icons.password,
                        loginScreenVM.passwordController, true, (value) {
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
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 30, left: 30),
                      child: TextButton(
                        onPressed: () {
                          loginScreenVM.authMange(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                            loginScreenVM.isUbload == true
                                ? "Loading..."
                                : "Log in",
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
              child: const Text.rich(
                TextSpan(
                  text: 'Dont have ',
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
                      text: 'Sign up',
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
