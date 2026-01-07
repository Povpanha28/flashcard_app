import 'package:flashcard_app/ui/screens/widgets/custombar.dart';
import 'package:flashcard_app/ui/screens/widgets/showCompleteDialog.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flip_card/flip_card.dart';
import 'widgets/back_NextWidget.dart';
import 'widgets/reviewCard.dart';
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
  final TextEditingController _noteCtrl = TextEditingController();
  final Map<Flashcard, String> _notes = {}; // one note per flashcard (attached to the object)

  @override
  void initState() {
    super.initState();
    flashcards = List.from(widget.deck.cards);
    currentIndex = widget.initialIndex; // Set initial index
    // load note for initial card (if any)
    _noteCtrl.text = _notes[flashcards[currentIndex]] ?? '';
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void nextCard() {
    // save current card note before moving
    _notes[flashcards[currentIndex]] = _noteCtrl.text;
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showFront = true;
      });
      // load note for the new current card
      _noteCtrl.text = _notes[flashcards[currentIndex]] ?? '';
    } else {
      // Show completion dialog when reaching the end
      showCompletionDialog();
    }
  }

  void previousCard() {
    // save current card note before moving
    _notes[flashcards[currentIndex]] = _noteCtrl.text;
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showFront = true;
      });
      // load note for the new current card
      _noteCtrl.text = _notes[flashcards[currentIndex]] ?? '';
    }
  }

  void shuffleCards() {
    setState(() {
      // save current note
      _notes[flashcards[currentIndex]] = _noteCtrl.text;
      flashcards.shuffle(Random());
      currentIndex = 0;
      showFront = true;
      // load note for new current card after shuffle
      _noteCtrl.text = _notes[flashcards[currentIndex]] ?? '';
    });
  }

  // pop up modal after flipping the last card
  void showCompletionDialog() async {
    // Update progress when review is complete
    await widget.onReviewComplete?.call();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Showcompletedialog(
        onTryAgain: () {
          Navigator.of(context).pop(); // Close dialog
          shuffleCards(); // Shuffle and restart
        },
        onLeave: () {
          Navigator.of(context).pop(); // Close dialog
          Navigator.of(context).pop(); // Exit review screen
        },
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
                  speed: 250,
                  flipOnTouch: true,
                  onFlipDone: (isFront) {
                    // Show dialog if last card and just flipped to back
                    if (currentIndex == flashcards.length - 1 && !isFront) {
                      showCompletionDialog();
                    }
                  },
                  front: buildCardSide(
                    label: 'Question',
                    content: currentCard.question,
                  ),
                  back: buildCardSide(
                    label: 'Answer',
                    content: currentCard.answer,
                  ),
                ),
              ),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _noteCtrl,
                  onChanged: (v) => _notes[flashcards[currentIndex]] = v,
                  maxLines: 2,
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
                    // Pill back button (fixed width)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: buildBackPill(
                        onPressed: previousCard,
                        enabled: currentIndex > 0,
                      ),
                    ),
                    // progress of cards
                    Text(
                      '${currentIndex + 1} / ${flashcards.length}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    // Shuffle Button
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 8),
                    //     child: ElevatedButton(
                    //       onPressed: shuffleCards,
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.white,
                    //         foregroundColor: Colors.black,
                    //         elevation: 2,
                    //         padding: EdgeInsets.symmetric(vertical: 16),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //           side: BorderSide(color: Colors.grey[300]!),
                    //         ),
                    //       ),
                    //       child: Text('Shuffle'),
                    //     ),
                    //   ),
                    // ),
                    // Next pill (fixed width)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: buildNextPill(
                        onPressed: currentIndex < flashcards.length - 1 ? nextCard : null,
                        enabled: currentIndex < flashcards.length - 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16), // extra space at bottom
            ],
          ),
        ),
      ),
    );
  }
}




