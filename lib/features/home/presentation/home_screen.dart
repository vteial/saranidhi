import 'package:flutter/material.dart';

/// The Home/Dashboard screen.
///
/// Will display: Mini-Oracle bar, Streak ribbon, AI Wisdom card,
/// and action grid in future sprints.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saranidhi'), centerTitle: true),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, size: 64),
            SizedBox(height: 16),
            Text(
              'The Treasure House of Breath',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Dashboard coming in Sprint 3+',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
