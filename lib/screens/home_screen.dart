import 'package:flutter/material.dart';
import 'package:eco_collect/auth/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Auth(); // Directly create an instance of Auth

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: const Color(0xFF2E7D32), // Dark green
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut(); // Sign out using the Auth instance
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to EcoCollect!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add navigation or functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50), // Green
              ),
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
