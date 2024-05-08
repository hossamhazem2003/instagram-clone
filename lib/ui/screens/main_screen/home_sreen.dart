import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/ui/screens/main_screen/home_screen_vm.dart';
import 'package:provider/provider.dart';

import '../add_post_tab/add_tab.dart';
import '../home_tab/home_tab.dart';
import '../profile_tab/profile_tab.dart';
import '../search_tab/search_tab.dart';

class MainScreen extends StatelessWidget {
  static final List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    SearchTab(),
    AddTab(),
    ProfileTab(uid: FirebaseAuth.instance.currentUser!.uid,),
  ];

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeScreenVM homeScreenVM = Provider.of<HomeScreenVM>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hossgram",
            style: TextStyle(fontSize: 25, fontFamily: 'instalogo1'),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.messenger_outline))],
        ),
        body: Center(
          child: _widgetOptions.elementAt(homeScreenVM.selectedIndex),
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            canvasColor: Colors.transparent
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Profile',
              ),
            ],
            currentIndex: homeScreenVM.selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: homeScreenVM.onItemTapped,
            unselectedItemColor: Colors.white,
          ),
        ),
      ),
    );
  }
}


/*

*/
