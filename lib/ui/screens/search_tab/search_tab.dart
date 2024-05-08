import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram/ui/screens/profile_tab/profile_tab.dart';
import 'package:instagram/ui/screens/search_tab/search_tab_vm.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  bool onPressedOnSearch = false;
  var searchController = TextEditingController();
  @override
  void initState() {
    onPressedOnSearch = false;
    super.initState();
  }

  @override
  void dispose() {
    searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchTabVm searchTabVm = SearchTabVm();

    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            onTap: () {
              setState(() {
                onPressedOnSearch = true;
              });
            },
            onFieldSubmitted: (value) {
              setState(() {
                searchTabVm.clearTxt(value);
              });
            },
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(Icons.search),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
          ),
          onPressedOnSearch == true
              ? Expanded(
                  child: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('user_name',
                              isGreaterThanOrEqualTo: searchController.text)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          return const Text('No users with this name');
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SafeArea(
                                        child: Scaffold(
                                          appBar: AppBar(
                                            title: const Text(
                                              "Hossgram",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontFamily: 'instalogo1'),
                                            ),
                                            elevation: 0,
                                            backgroundColor: Colors.transparent,
                                            actions: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                      Icons.messenger_outline))
                                            ],
                                          ),
                                          body: ProfileTab(
                                              uid: snapshot.data!.docs[index]
                                                  ['user_id']),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: users(
                                    snapshot.data!.docs[index]['user_name'],
                                    snapshot.data!.docs[index]['url_image']),
                              );
                            });
                      }))
              : Expanded(
                  child: FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection('posts').get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.none) {
                          return const Text('No users with this name');
                        }
                        return MasonryGridView.count(
                          itemCount: snapshot.data!.docs.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 3,
                          itemBuilder: (context, index) {
                            return Image.network(
                              snapshot.data!.docs[index]['postUrl'],
                              fit: BoxFit.cover,
                            );
                          },
                        );
                      }))
        ],
      ),
    );
  }

  Widget users(String username, String profImage) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(profImage),
            radius: 16,
          ),
          SizedBox(
            width: 10,
          ),
          Text(username)
        ],
      ),
    );
  }
}
/*
GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    child: Image.network(''),
                  );
                },
              )
*/