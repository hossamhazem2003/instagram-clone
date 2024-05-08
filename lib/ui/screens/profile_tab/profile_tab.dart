import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/auth/login_screen.dart';
import 'package:instagram/ui/screens/profile_tab/profile_tab_vm.dart';
import 'package:instagram/ui/widgets/follow_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ProfileTab extends StatelessWidget {
  String uid;
  ProfileTab({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    ProfileTabVM profileTabVM = Provider.of(context, listen: true);
    return SafeArea(
      child: Scaffold(
        body: uid.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Wrong!'),
                    );
                  }

                  final data = snapshot.data!.data();

                  int followersCount = data?['user_followers'].length ?? 0;
                  int followingCount = data?['user_following'].length ?? 0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            data!['user_name'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          )),
                      Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(data['url_image']),
                            radius: 45,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('posts')
                                                  .where('uid', isEqualTo: uid)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Text('-');
                                                }
                                                return Text(
                                                  '${snapshot.data!.docs.length}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                );
                                              }),
                                          const Text("Posts",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('$followingCount',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          const Text('followers',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('$followersCount',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          const Text("followings",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15))
                                        ],
                                      ),
                                    ],
                                  ),
                                  FirebaseAuth.instance.currentUser!.uid == uid
                                      ? FollowButton(
                                          backgroundColor: Colors.transparent,
                                          borderColor: Colors.white,
                                          text: "Sign out",
                                          textColor: Colors.white,
                                          function: () async {
                                            profileTabVM.signOut();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginScreen()),
                                            );
                                          },
                                        )
                                      : profileTabVM.isFollowing == false || followingCount == 0
                                          ? FollowButton(
                                              backgroundColor: Colors.blue,
                                              borderColor: Colors.white,
                                              text: "Follow",
                                              textColor: Colors.white,
                                              function: () async {
                                                await profileTabVM.manageFollow(
                                                  data[
                                                      'user_id'], // Update the arguments
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                );
                                              },
                                            )
                                          : FollowButton(
                                              backgroundColor:
                                                  Colors.transparent,
                                              borderColor: Colors.white,
                                              text: "Unfollow",
                                              textColor: Colors.white,
                                              function: () async {
                                                await profileTabVM
                                                    .manageUNFollow(
                                                  data[
                                                      'user_id'], // Update the arguments
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                );
                                              },
                                            )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          data['user_name'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          data['user_bio'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .where('uid', isEqualTo: uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Image.network(
                                        snapshot.data!.docs[index]['postUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}
