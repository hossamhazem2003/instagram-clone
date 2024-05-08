import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/comments_screen/comment_screen_vm.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    CommentScreenVM commentsScreenVM = Provider.of(context);
    //commentsScreenVM.getUserData();
    //print('bio ${commentsScreenVM.getUser.bio}');

    final Map<String, String> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String postId = arguments['postId'] ?? 'no-postid';

    final user = commentsScreenVM.getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: commentsScreenVM.isUbload == true
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return comments(
                        snapshot.data!.docs[index]['name'],
                        snapshot.data!.docs[index]['profilePic'],
                        snapshot.data!.docs[index]['text'],
                        DateFormat.yMMMd().format(
                          snapshot.data!.docs[index]['datePublished'].toDate(),
                        ));
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
      bottomNavigationBar: Form(
        key: commentsScreenVM.formKey,
        child: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentsScreenVM.addCommentController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.name}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    commentsScreenVM.addComment(
                        postId, user.id, user.name, user.imageUrl);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox comments(
      String username, String profileImage, String comment, String date) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(profileImage),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '$username ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: comment,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      date,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
