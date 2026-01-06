import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcardform.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcartile.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/models/deck.dart';

class CardList extends StatefulWidget {
  const CardList({super.key, required this.deck, this.onCardChanged});

  final Deck deck;
  final Future<void> Function()? onCardChanged;

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
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
      // Save changes when a card is edited
      await widget.onCardChanged?.call();
    }
  }

  Future<void> onDelete(Flashcard card) async {
    final index = widget.deck.cards.indexWhere((c) => c.id == card.id);
    if (index == -1) return;

    setState(() {
      widget.deck.removeCard(card.id);
    });

    await widget.onCardChanged?.call();

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();

    ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? controller;

    controller = messenger.showSnackBar(
      SnackBar(
        content: const Text('Flashcard deleted'),
        behavior: SnackBarBehavior.fixed, // ✅ REQUIRED on Windows
        duration: const Duration(days: 1), // disable auto
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            setState(() {
              widget.deck.insertCard(index, card);
            });
            await widget.onCardChanged?.call();
            controller?.close(); // close immediately
          },
        ),
      ),
    );

    // ✅ Force auto-dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) controller?.close();
    });
  }

  Future<void> onToggleKnown(Flashcard card, bool isKnown) async {
    final updatedCard = card.copyWith(isKnown: isKnown);
    setState(() {
      widget.deck.updateFlashcard(card.id, updatedCard);
    });
    await widget.onCardChanged?.call();
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
        return FlashcardTile(
          deck: widget.deck,
          card: card,
          onEdit: onEdit,
          onDelete: onDelete,
          onToggleKnown: onToggleKnown,
        );
      },
    );

    return content;
  }
}
