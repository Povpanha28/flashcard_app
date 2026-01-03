import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 70,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu_book,
              color: Color(0xFF6366F1),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FlashLearn',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                'Your journey to mastery begins here',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
      // actions: [
      //   Container(
      //     margin: const EdgeInsets.only(right: 16),
      //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      //     decoration: BoxDecoration(
      //       gradient: const LinearGradient(
      //         colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
      //       ),
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     child: const Row(
      //       children: [
      //         Icon(Icons.star, color: Colors.white, size: 16),
      //         SizedBox(width: 4),
      //         Text(
      //           '0 XP',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 14,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ],
    );
  }
}