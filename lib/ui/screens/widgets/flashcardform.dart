import 'package:flashcard_app/models/flashcard.dart';
import 'package:flutter/material.dart';

class FlashcardForm extends StatefulWidget {
  const FlashcardForm({super.key, this.flashcard});

  /// If provided, the form will be in edit mode
  final Flashcard? flashcard;

  @override
  State<FlashcardForm> createState() => _FlashcardFormState();
}

class _FlashcardFormState extends State<FlashcardForm> {
  final TextEditingController questionCtrl = TextEditingController();
  final TextEditingController answerCtrl = TextEditingController();

  bool get isEditMode => widget.flashcard != null;

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      questionCtrl.text = widget.flashcard!.question;
      answerCtrl.text = widget.flashcard!.answer;
    }
    questionCtrl.addListener(() => setState(() {}));
    answerCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    questionCtrl.dispose();
    answerCtrl.dispose();
    super.dispose();
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      Flashcard result;
      if (isEditMode) {
        result = widget.flashcard!.copyWith(
          question: questionCtrl.text,
          answer: answerCtrl.text,
        );
      } else {
        result = Flashcard(
          question: questionCtrl.text,
          answer: answerCtrl.text,
        );
      }
      Navigator.pop(context, result);
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
            _header(isEditMode ? "Edit Flashcard" : "Create New Flashcard"),
            const SizedBox(height: 24),
            _label("Question"),
            const SizedBox(height: 8),
            _textField(
              validator: _validateText,
              controller: questionCtrl,
              hint: "e.g., What is the capital of France?",
            ),

            const SizedBox(height: 16),

            _label("Answer"),
            const SizedBox(height: 8),
            _textField(
              validator: _validateText,
              controller: answerCtrl,
              hint: "e.g. Paris",
            ),
            const SizedBox(height: 24),
            _flashcardPreview(),
            const SizedBox(height: 24),
            _buttons(context),
          ],
        ),
      ),
    );
  }

  Row _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _button("Cancel", onCancel, Colors.grey.shade200, Colors.black),

        const SizedBox(width: 16),
        _button(
          isEditMode ? "Save" : "Create",
          onSave,
          Color(0xFF6366F1),
          Colors.white,
        ),
      ],
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
        IconButton(onPressed: onCancel, icon: Icon(Icons.close)),
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

  Widget _flashcardPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Container(
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
              const Text(
                'Question',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                questionCtrl.text.isEmpty
                    ? 'Your question will appear here...'
                    : questionCtrl.text,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
              const SizedBox(height: 16),
              const Text(
                'Answer',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                answerCtrl.text.isEmpty
                    ? 'Your answer will appear here...'
                    : answerCtrl.text,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
