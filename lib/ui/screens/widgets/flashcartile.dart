import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flutter/material.dart';

class FlashcardTile extends StatefulWidget {
  const FlashcardTile({
    super.key,
    required this.card,
    required this.deck,
    this.onEdit,
    this.onDelete,
    this.onToggleKnown,
    this.initialIndex = 0,
  });

  final Flashcard card;
  final Deck deck;
  final void Function(Flashcard)? onEdit;
  final void Function(Flashcard)? onDelete;
  final void Function(Flashcard, bool)? onToggleKnown;
  final int initialIndex;

  @override
  State<FlashcardTile> createState() => _FlashcardTileState();
}

class _FlashcardTileState extends State<FlashcardTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.onEdit != null
          ? () => widget.onEdit!(widget.card)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFFDF2F8), Color(0xFFF8E8F8)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // isKnown status chip at top right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Compact pill-style toggle
                  GestureDetector(
                    onTap: () {
                      widget.onToggleKnown?.call(
                        widget.card,
                        !widget.card.isKnown,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: widget.card.isKnown
                            ? Colors.green.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.card.isKnown
                              ? Colors.green.withOpacity(0.5)
                              : Colors.orange.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.card.isKnown
                                ? Icons.check_circle_rounded
                                : Icons.hourglass_bottom_rounded,
                            size: 14,
                            color: widget.card.isKnown
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.card.isKnown ? 'Mastered' : 'Learning',
                            style: TextStyle(
                              fontSize: 11,
                              color: widget.card.isKnown
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Question text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.card.question,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 20,
                          color: Colors.purple,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      if (widget.onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          color: Colors.blue,
                          onPressed: () => widget.onEdit?.call(widget.card),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      if (widget.onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          color: Colors.red,
                          onPressed: () => widget.onDelete?.call(widget.card),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ],
              ),

              if (_isExpanded)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),

                    Text(
                      'Answer',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.card.answer,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
