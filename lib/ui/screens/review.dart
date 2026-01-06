import 'package:flashcard_app/ui/screens/widgets/custombar.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flashcard_app/ui/screens/widgets/Card.dart';
import 'dart:math';

class FlashcardReview extends StatefulWidget {
  final Deck deck;
  final int initialIndex;
  final Future<void> Function()? onReviewComplete;

  const FlashcardReview({
    Key? key,
    required this.deck,
    this.initialIndex = 0,
    this.onReviewComplete,
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

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showFront = true;
      });
    } else {
      // Show completion dialog when reaching the end
      showCompletionDialog();
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

  // pop up modal after flipping the last card
  void showCompletionDialog() async {
    // Update progress when review is complete
    await widget.onReviewComplete?.call();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration, color: Colors.purple, size: 48),
              const SizedBox(height: 16),
              Text(
                'Review Complete!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'You have reached the end of the deck.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          currentIndex = 0;
                          showFront = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Try Again',
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).maybePop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Leave',
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardSide({required String label, required String content}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentCard = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Main Card
              Container(
                width: double.infinity,
                height: 500,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: FlipCard(
                  flipOnTouch: true,
                  onFlipDone: (isFront) {
                    // Show dialog if last card and just flipped to back
                    if (currentIndex == flashcards.length - 1 && !isFront) {
                      showCompletionDialog();
                    }
                  },
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
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Note',
                    hintText: 'Enter your note here',
                    prefixIcon: Icon(Icons.note),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
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
                          onPressed: currentIndex < flashcards.length - 1
                              ? nextCard
                              : null,
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
      ),
    );
  }
}
