import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram/ui/screens/add_post_tab/add_post_tab_vm.dart';
import 'package:instagram/ui/screens/auth/auth_vm.dart';
import 'package:instagram/ui/screens/auth/login_screen.dart';
import 'package:instagram/ui/screens/comments_screen/comment_screen_vm.dart';
import 'package:instagram/ui/screens/home_tab/home_tab_vm.dart';
import 'package:instagram/ui/screens/main_screen/home_screen_vm.dart';
import 'package:instagram/ui/screens/main_screen/home_sreen.dart';
import 'package:instagram/ui/screens/profile_tab/profile_tab_vm.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthVM()),
        ChangeNotifierProvider(create: (context) => HomeScreenVM()),
        ChangeNotifierProvider(create: (context) => HomeTabVM()),
        ChangeNotifierProvider(create: (context) => AddPostTabVm()),
        ChangeNotifierProvider(create: (context) => ProfileTabVM()),
        ChangeNotifierProvider(create: (context) => CommentScreenVM()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const MainScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
