import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/add_post_tab/add_post_tab_vm.dart';

selectImage(BuildContext context,AddPostTabVm addPostTabVm) {
// can i ignore using Provider here?
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Create a post'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: const Text('from gallery'),
                onTap: () {
                  // Handle "from gallery" option
                  addPostTabVm.imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: const Text('from camera'),
                onTap: () {
                  // Handle "from camera" option
                  addPostTabVm.imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: const Text('cancel'),
                onTap: () {
                  // Handle "cancel" option
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
