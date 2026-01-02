import 'package:flutter/material.dart';

class DeckForm extends StatelessWidget {
  const DeckForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Important: handles keyboard overlap
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch, // full width
        children: [
          const Text(
            'Create New Deck',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Deck Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Deck Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Create Deck'),
          ),
        ],
      ),
    );
  }
}
