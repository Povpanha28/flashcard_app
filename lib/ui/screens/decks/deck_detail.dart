import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/ui/screens/review.dart'; // Add this import
import 'package:flutter/material.dart';

class DeckDetail extends StatelessWidget {
  const DeckDetail({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deck.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deck.description,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Number of Cards: ${deck.cards.length}',
              style: const TextStyle(fontSize: 16),
            ),
            Expanded(child: CardList(deck:  deck)),
          ],
        ),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: deck.cards.length,
      itemBuilder: (context, index) {
        final card = deck.cards[index];
        return ListTile(
          title: Text(card.question),
          subtitle: Text(card.answer),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardReview(
                  deck: deck,
                  initialIndex: index, // Pass the tapped card's index
                ),
              ),
            );
          },
        );
      },
    );
  }
}
