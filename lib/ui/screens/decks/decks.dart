import 'package:flashcard_app/data/mock_data.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/ui/screens/widgets/deck_form.dart';
import 'package:flashcard_app/ui/screens/widgets/custombar.dart';
import 'package:flashcard_app/ui/screens/widgets/deckcard.dart';
import 'package:flutter/material.dart';

class Decks extends StatefulWidget {
  // final Deck deck;
  const Decks({super.key});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> {
  Future<void> onCreate() async {
    final deck = await showModalBottomSheet<Deck>(
      isScrollControlled: true,
      context: context,
      builder: (context) => const DeckForm(),
    );

    if (deck != null) {
      setState(() {
        mockDecks.add(deck);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Decks Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first flashcard deck\nto start learning!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Create Deck'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );

    if (mockDecks.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        itemCount: mockDecks.length,
        itemBuilder: (context, index) => DeckCard(deck: mockDecks[index]),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar:  const CustomAppBar(),
      body: content,
      floatingActionButton: mockDecks.isNotEmpty
          ? FloatingActionButton(
              onPressed: onCreate,
              backgroundColor: const Color(0xFF6366F1),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

