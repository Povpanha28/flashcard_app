import 'package:flashcard_app/data/mock_data.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/ui/screens/decks/deck_detail.dart';
import 'package:flashcard_app/ui/screens/decks/deck_form.dart';
import 'package:flutter/material.dart';

class Decks extends StatelessWidget {
  const Decks({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No Deck is created yet.'));

    if (mockDecks.isNotEmpty) {
      content = ListView.builder(
        itemCount: mockDecks.length,
        itemBuilder: (context, index) => DeckTile(deck: mockDecks[index]),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) {
                  return DeckForm();
                },
              );
            },
          ),
        ],
      ),
      body: Center(child: content),
    );
  }
}

class DeckTile extends StatelessWidget {
  const DeckTile({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => DeckDetail(deck: deck),
          ),
        );
      },
      leading: Icon(deck.icon, color: deck.color),
      title: Row(children: [Text(deck.title)]),
      subtitle: Text(deck.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.layers, size: 18),
          const SizedBox(width: 4),
          Text(deck.cards.length.toString()),
        ],
      ),
    );
  }
}
