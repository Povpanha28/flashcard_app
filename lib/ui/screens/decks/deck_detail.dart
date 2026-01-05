import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/ui/screens/review.dart'; // Add this import
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/ui/screens/widgets/cardlist.dart';
import 'package:flashcard_app/ui/screens/widgets/custombar.dart';
import 'package:flashcard_app/ui/screens/widgets/flashcardform.dart';
import 'package:flutter/material.dart';

class DeckDetail extends StatefulWidget {
  const DeckDetail({super.key, required this.deck, this.onDeckUpdated});

  final Deck deck;
  final Future<void> Function()? onDeckUpdated;

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
      // Save changes when a new card is added
      await widget.onDeckUpdated?.call();
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
            DeckCardDetail(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Flashcards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),

                IconButton(onPressed: onCreate, icon: Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CardList(
                deck: widget.deck,
                onCardChanged: widget.onDeckUpdated,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DeckCardDetail() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.deck.color!,
                      widget.deck.color!.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.deck.icon, color: Colors.white, size: 28),
              ),

              SizedBox(width: 12),
              // Deck name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.deck.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    widget.deck.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Mastery row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Mastery',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: widget.deck.progress?.mastery != null
                  ? widget.deck.progress!.mastery / 100
                  : 0,
              minHeight: 6,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),

          const SizedBox(height: 12),

          // Cards count
          Row(
            children: [
              Icon(Icons.copy_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 6),
              Text(
                '${widget.deck.cards.length} cards',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Review Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.play_arrow_rounded),
              label: Text('Review'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onPressed: widget.deck.cards.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlashcardReview(deck: widget.deck),
                        ),
                      );
                    },
            ),
          ),
        ],
      ),
    );
  }
}
