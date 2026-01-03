import 'package:flashcard_app/data/data_repostiy.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcardform.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcartile.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/models/deck.dart';

class CardList extends StatefulWidget {
  const CardList({super.key, required this.deck});

  final Deck deck;

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  final DataRepository _repository = DataRepository();

  Future<void> onEdit(Flashcard card) async {
    final updatedCard = await showModalBottomSheet<Flashcard>(
      isScrollControlled: true,
      context: context,
      builder: (context) => FlashcardForm(flashcard: card),
    );

    if (updatedCard != null) {
      setState(() {
        widget.deck.updateFlashcard(card.id, updatedCard);
      });
      await _repository.saveDecks();
    }
  }

  void onDelete(Flashcard card) {
    final index = widget.deck.cards.indexWhere((c) => c.id == card.id);

    setState(() {
      widget.deck.removeCard(card.id);
    });
    _repository.saveDecks();

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flashcard deleted'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.deck.insertCard(index, card);
            });
            _repository.saveDecks();
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.deck.cards.isEmpty) {
      return Center(
        child: Text(
          'No flashcards in this deck yet.\nTap the + button to add some!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    Widget content = ListView.builder(
      itemCount: widget.deck.cards.length,
      itemBuilder: (context, index) {
        final card = widget.deck.cards[index];
        return FlashcardTile(card: card, onEdit: onEdit, onDelete: onDelete);
      },
    );

    return content;
  }
}
