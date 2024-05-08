import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/add_post_tab/add_post_tab_vm.dart';
import 'package:instagram/ui/widgets/custom_txtfield.dart';
import 'package:instagram/ui/widgets/select_image.dart';
import 'package:provider/provider.dart';

class AddTab extends StatelessWidget {
  const AddTab({super.key});

  @override
  Widget build(BuildContext context) {
    AddPostTabVm addPostTabVm = Provider.of(context);
    return Scaffold(
      body: Form(
        key: addPostTabVm.formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Consumer<AddPostTabVm>(builder: (context, value, child) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: value.selectedPostImage == null
                        ? null
                        : FileImage(File(value.selectedPostImage!.path)),
                    radius: 45,
                  );
                }),
                Expanded(
                  child: customTextFField('Enter Your Caption', Icons.abc,
                      addPostTabVm.captionController, false, (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a caption for your post!';
                    }
                    return null;
                  }),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: addPostTabVm.getUserData(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
      
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          addPostTabVm.addPost(
                              snapshot.data!['user_id'],
                              snapshot.data!['user_name'],
                              snapshot.data!['url_image']);
                        },
                        child: const Text(
                          'POST +',
                          style: TextStyle(color: Colors.white),
                        )),
                  );
                }),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  selectImage(context, addPostTabVm);
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(50),
                ),
                child: const Text('ADD POST PHOTO')),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}