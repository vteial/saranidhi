import 'package:flutter/material.dart';

/// The Breath Journal screen.
///
/// Will display: Two-click breath entry, alignment status,
/// timer, history list in Sprint 3.
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breath Journal'), centerTitle: true),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.self_improvement, size: 64),
            SizedBox(height: 16),
            Text(
              'Sara Kalai Breath Journal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Breath logging coming in Sprint 3',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
