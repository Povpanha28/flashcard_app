import 'package:flutter/material.dart';

class Decks extends StatelessWidget {
  const Decks({super.key});
  @override
  Widget build(BuildContext context) {
    final List<String> items = List<String>.generate(20, (i) => 'Item $i');

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("MyFlashcardDeck")),
      body: ListView.builder(
        itemCount: items.length, // Total number of items
        itemBuilder: (context, index) {
          // This callback is called for each visible item
          return ListTile(
            title: Text(items[index]),
            subtitle: Text('This is item number $index'),
          );
        },
      ),
    );
  }
}
