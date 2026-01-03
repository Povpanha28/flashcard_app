import 'package:flashcard_app/models/deck.dart';
import 'package:flutter/material.dart';

class DeckForm extends StatefulWidget {
  const DeckForm({super.key});

  @override
  State<DeckForm> createState() => _DeckFormState();
}

class _DeckFormState extends State<DeckForm> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  IconData selectedIcon = Icons.public;
  Color selectedColor = Colors.purple;

  final List<IconData> icons = [
    Icons.menu_book,
    Icons.palette,
    Icons.science,
    Icons.public,
    Icons.laptop,
    Icons.music_note,
    Icons.directions_run,
    Icons.search,
    Icons.flight,
    Icons.theater_comedy,
    Icons.account_balance,
    Icons.bar_chart,
  ];

  final List<Color> colors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.deepPurple,
    Colors.teal,
    Colors.deepOrange,
  ];

  void onCreate() {
    if (_formKey.currentState!.validate()) {
      Deck newDeck = Deck(
        title: nameCtrl.text,
        description: descCtrl.text,
        icon: selectedIcon,
        color: selectedColor,
      );
      Navigator.pop(context, newDeck);
    }
  }

  void onCancel() {
    Navigator.pop(context);
  }

  String? _validateText(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please fill out this field';
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header("Create New Deck"),
            const SizedBox(height: 24),
            _label("Deck Name"),
            const SizedBox(height: 8),
            _textField(
              validator: _validateText,
              controller: nameCtrl,
              hint: "e.g., Spanish Vocabulary, World Capitals...",
            ),

            const SizedBox(height: 16),

            _label("Description"),
            const SizedBox(height: 8),
            _textField(
              validator: _validateText,
              controller: descCtrl,
              hint: "e.g., Basic phrases, Advanced grammar...",
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            _label("Choose an Icon"),
            const SizedBox(height: 8),
            _iconGrid(),

            const SizedBox(height: 24),

            _label("Choose a Color"),
            const SizedBox(height: 8),
            _colorGrid(),

            const SizedBox(height: 24),

            _label("Preview"),
            const SizedBox(height: 8),
            _previewCard(),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _button("Cancel", onCancel, Colors.grey.shade200, Colors.black),

                const SizedBox(width: 16),
                _button(
                  "Create Deck",
                  onCreate,
                  Color(0xFF6366F1),
                  Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Widgets ----------

  Widget _header(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        IconButton(
          onPressed: onCancel,
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _iconGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: icons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final icon = icons[index];
        final selected = icon == selectedIcon;

        return GestureDetector(
          onTap: () => setState(() => selectedIcon = icon),
          child: Container(
            decoration: BoxDecoration(
              color: selected
                  ? selectedColor.withOpacity(0.15)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(color: Colors.black, width: 1.5)
                  : null,
            ),
            child: Icon(icon, color: selected ? selectedColor : Colors.black54),
          ),
        );
      },
    );
  }

  Widget _colorGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: colors.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final color = colors[index];
        final selected = color == selectedColor;

        return GestureDetector(
          onTap: () => setState(() => selectedColor = color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              border: selected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _button(
    String text,
    VoidCallback onPressed,
    Color bgColor,
    Color fgColor,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _previewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [selectedColor, selectedColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(selectedIcon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameCtrl.text.isEmpty ? "Deck Name" : nameCtrl.text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                descCtrl.text.isEmpty ? "Deck description..." : descCtrl.text,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
