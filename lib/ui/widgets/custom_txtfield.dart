import 'package:flutter/material.dart';

Widget customTextFField(String hintText, IconData icon, TextEditingController controller, bool secure, FormFieldValidator<String>? validator) {
  return Container(
    color: const Color(0xff191819),
    margin: const EdgeInsets.only(right: 30, left: 30),
    child: TextFormField(
      controller: controller,
      obscureText: secure,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      validator: validator,
    ),
  );
}


/*
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
*/ 