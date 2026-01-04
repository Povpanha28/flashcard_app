import 'package:flutter/material.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flashcard_app/ui/screens/widgets/Card.dart';
import 'dart:math';

class FlashcardReview extends StatefulWidget {
  final Deck deck;
  final int initialIndex; // Add this

  const FlashcardReview({
    Key? key,
    required this.deck,
    this.initialIndex = 0, // Default to 0
  }) : super(key: key);

  @override
  State<FlashcardReview> createState() => _FlashcardReviewState();
}

class _FlashcardReviewState extends State<FlashcardReview> {
  int currentIndex = 0;
  bool showFront = true;
  List<Flashcard> flashcards = [];

  @override
  void initState() {
    super.initState();
    flashcards = List.from(widget.deck.cards);
    currentIndex = widget.initialIndex; // Set initial index
  }

  void flipCard() {
    setState(() {
      showFront = !showFront;
    });
  }

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showFront = true;
      });
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showFront = true;
      });
    }
  }

  void shuffleCards() {
    setState(() {
      flashcards.shuffle(Random());
      currentIndex = 0;
      showFront = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: Color(0xFF6366F1),
        appBar: AppBar(
          title: Text('No Flashcards'),
        ),
        body: Center(
          child: Text('This deck has no flashcards'),
        ),
      );
    }

    Flashcard currentCard = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Flashcard ${currentIndex + 1}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main Card
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: FlipCard(
                  flipOnTouch: true,
                  front: buildCardSide(
                    label: 'Front',
                    content: currentCard.question,
                  ),
                  back: buildCardSide(
                    label: 'Back',
                    content: currentCard.answer,
                  ),
                ),
              ),
            ),
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: currentIndex > 0 ? previousCard : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey,
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text('Previous'),
                      ),
                    ),
                  ),
                  // Shuffle Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: shuffleCards,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text('Shuffle'),
                      ),
                    ),
                  ),
                  // Next Button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: currentIndex < flashcards.length - 1 ? nextCard : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey,
                          elevation: 2,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text('Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


