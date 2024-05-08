import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/comments_screen/comments_screen.dart';
import 'package:instagram/ui/screens/home_tab/home_tab_vm.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    HomeTabVM homeTabVM = Provider.of(context, listen: false);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting ||
              homeTabVM.error.isNotEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Text('No posts available');
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return postInfo(
                context,
                doc['postUrl'],
                doc['username'],
                doc['profImage'],
                doc['likes'],
                doc['description'],
                DateFormat.yMMMd().format(doc['datePublished'].toDate()),
                homeTabVM,
                doc['postId'],
                FirebaseAuth.instance.currentUser!.uid,
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }

  Widget postInfo(
    BuildContext context,
    String postImageUrl,
    String username,
    String profileImage,
    List likes,
    String description,
    String date,
    HomeTabVM homeTabVM,
    String postId,
    String uid,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(profileImage),
                  radius: 20,
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Options'),
                              content: InkWell(
                                  onTap: () {
                                    homeTabVM.deletePost(postId);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete the post')),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Image.network(
                postImageUrl,
                fit: BoxFit.fill,
              )),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    homeTabVM.manageLikes(postId, uid, likes);
                  },
                  icon: Icon(
                    likes.contains(uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          settings: RouteSettings(arguments: {
                            'postId': postId,
                            'name': username,
                            'uid': uid,
                            'profileImage': profileImage
                          }),
                          builder: (context) => CommentsScreen()),
                    );
                  },
                  icon: const Icon(Icons.comment_outlined)),
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text('Share the post'),
                          content: SingleChildScrollView(
                            child: Text(postImageUrl),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.send)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('${likes.length} likes'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text.rich(
              TextSpan(
                text: '$username ',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white),
                children: [
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(arguments: {
                      'postId': postId,
                      'name': username,
                      'uid': uid,
                      'profileImage': profileImage
                    }),
                    builder: (context) => CommentsScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'View all comments',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              date,
              style: const TextStyle(color: Colors.white54),
            ),
          )
        ],
      ),
    );
  }
}
