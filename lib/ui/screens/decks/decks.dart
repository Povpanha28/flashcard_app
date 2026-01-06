import 'package:flashcard_app/data/data_reposity.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/ui/screens/decks/deck_detail.dart';
import 'package:flashcard_app/ui/screens/widgets/deck_form.dart';
import 'package:flashcard_app/ui/screens/widgets/custombar.dart';
import 'package:flashcard_app/ui/screens/widgets/deckcard.dart';
import 'package:flutter/material.dart';

class Decks extends StatefulWidget {
  const Decks({super.key});

  @override
  State<Decks> createState() => _DecksState();
}

class _DecksState extends State<Decks> {
  final DataReposity _repository = DataReposity.instance;
  List<Deck> _decks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    final loadedDecks = await _repository.loadDecks();
    setState(() {
      _decks = loadedDecks;
      _isLoading = false;
    });
  }

  Future<void> onCreate() async {
    final deck = await showModalBottomSheet<Deck>(
      isScrollControlled: true,
      context: context,
      builder: (context) => const DeckForm(),
    );

    if (deck != null) {
      setState(() {
        _decks.add(deck);
      });
      await _repository.saveDecks(_decks);
    }
  }

  Future<void> onEdit(Deck deck, int index) async {
    final updatedDeck = await showModalBottomSheet<Deck>(
      isScrollControlled: true,
      context: context,
      builder: (context) => DeckForm(deck: deck),
    );

    if (updatedDeck != null) {
      setState(() {
        _decks[index] = updatedDeck;
      });
      await _repository.saveDecks(_decks);
    }
  }

  Future<void> onDelete(Deck deck, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Deck'),
        content: Text(
          'Are you sure you want to delete "${deck.title}"?\n\nThis will also delete all ${deck.cards.length} flashcards in this deck.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final deletedDeck = _decks[index];
      setState(() {
        _decks.removeAt(index);
      });
      await _repository.saveDecks(_decks);

      if (!mounted) return;

      final messenger = ScaffoldMessenger.of(context);

      messenger.removeCurrentSnackBar();

      ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? controller;

      controller = messenger.showSnackBar(
        SnackBar(
          content: Text('Deck "${deletedDeck.title}" deleted'),
          behavior: SnackBarBehavior.fixed,
          duration: const Duration(days: 1), // disable auto
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              setState(() {
                _decks.insert(index, deletedDeck);
              });
              await _repository.saveDecks(_decks);

              controller?.close(); // ✅ now safe
            },
          ),
        ),
      );

      // Force dismiss after 3 seconds (Windows fix)
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) controller?.close();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: const CustomAppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

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

    if (_decks.isNotEmpty) {
      content = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        itemCount: _decks.length,
        itemBuilder: (context, index) => DeckCard(
          deck: _decks[index],
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeckDetail(
                  deck: _decks[index],
                  onDeckUpdated: () async {
                    await _repository.saveDecks(_decks);
                  },
                ),
              ),
            );
            setState(() {});
            await _repository.saveDecks(_decks);
          },
          onEdit: () => onEdit(_decks[index], index),
          onDelete: () => onDelete(_decks[index], index),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const CustomAppBar(),
      body: content,
      floatingActionButton: _decks.isNotEmpty
          ? FloatingActionButton(
              onPressed: onCreate,
              backgroundColor: const Color(0xFF6366F1),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
