import 'package:flutter/material.dart';
import 'package:eco_collect/auth/auth.dart';
import 'package:eco_collect/screens/home_screen.dart';
import 'package:eco_collect/auth/auth_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Auth(); // Directly create an instance of Auth

    return StreamBuilder<CustomUser?>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final CustomUser? user = snapshot.data;
          if (user == null) {
            return const AuthScreen(); // Show AuthScreen if no user is signed in
          }
          return const HomeScreen(); // Show HomeScreen if user is signed in
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
