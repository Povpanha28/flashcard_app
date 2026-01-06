import 'package:flashcard_app/models/deck.dart';
import 'package:flutter/material.dart';

class DeckCard extends StatelessWidget {
  final Deck deck;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DeckCard({
    super.key,
    required this.deck,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _formatLastReviewed(DateTime? lastReviewed) {
    if (lastReviewed == null) return 'Never reviewed';

    final now = DateTime.now();
    final difference = now.difference(lastReviewed);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
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
                            deck.color!,
                            deck.color!.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(deck.icon, color: Colors.white, size: 28),
                    ),

                    SizedBox(width: 12),
                    // Deck name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deck.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Description
                          Text(
                            deck.description,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, color: Colors.red),
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
                    value:
                        deck.progress?.getMastery(
                              deck.progress!.getKnownCount(deck.cards),
                              deck.progress!.getTotalCount(deck.cards),
                            ) !=
                            null
                        ? deck.progress!.getMastery(
                            deck.progress!.getKnownCount(deck.cards),
                            deck.progress!.getTotalCount(deck.cards),
                          )
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
                      '${deck.cards.length} cards',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      _formatLastReviewed(deck.progress?.lastReviewed),
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
