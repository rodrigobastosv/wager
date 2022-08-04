import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wager/pages/home/home_page.dart';
import 'package:wager/pages/sign_in/sign_in_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            if (user != null) {
              return const HomePage();
            } else {
              return const SignInPage();
            }
          }
          return const SignInPage();
        },
      ),
    );
  }
}
