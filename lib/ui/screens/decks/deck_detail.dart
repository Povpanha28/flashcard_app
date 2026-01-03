import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/ui/screens/widgets/custombar.dart';
import 'package:flashcard_app/ui/screens/widgets/deckcard.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcardform.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcartile.dart';
import 'package:flutter/material.dart';

class DeckDetail extends StatefulWidget {
  const DeckDetail({super.key, required this.deck});

  final Deck deck;

  @override
  State<DeckDetail> createState() => _DeckDetailState();
}

class _DeckDetailState extends State<DeckDetail> {
  Future<void> onCreate() async {
    final newCard = await showModalBottomSheet<Flashcard>(
      isScrollControlled: true,
      context: context,
      builder: (context) => const FlashcardForm(),
    );

    if (newCard != null) {
      setState(() {
        widget.deck.addCard(newCard);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DeckCard(deck: widget.deck),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Flashcards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.purple,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: CardList(deck: widget.deck)),
          ],
        ),
      ),
      floatingActionButton: widget.deck.cards.isNotEmpty
          ? FloatingActionButton(
              onPressed: onCreate,
              backgroundColor: const Color(0xFF6366F1),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class CardList extends StatelessWidget {
  const CardList({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    if (deck.cards.isEmpty) {
      return Center(
        child: Text(
          'No flashcards in this deck yet.\nTap the + button to add some!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }
    Widget content = ListView.builder(
      itemCount: deck.cards.length,
      itemBuilder: (context, index) {
        final card = deck.cards[index];
        return FlashcardTile(card: card);
      },
    );

    return content;
  }
}
