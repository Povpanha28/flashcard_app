import 'dart:convert';
import 'dart:io';

import 'package:flashcard_app/models/deck.dart';
import 'package:path_provider/path_provider.dart';

class DataReposity {
  static const String _fileName = 'decks.json';
  static DataReposity? _instance;

  DataReposity._();

  /// Singleton instance
  static DataReposity get instance {
    _instance ??= DataReposity._();
    return _instance!;
  }

  /// Get the local file path for storing decks
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  /// Load decks from JSON file
  Future<List<Deck>> loadDecks() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      if (content.isEmpty) {
        return [];
      }
      final List<dynamic> jsonData = jsonDecode(content);
      return jsonData.map((data) => Deck.fromJson(data)).toList();
    } catch (e) {
      print('Error loading decks: $e');
      return [];
    }
  }

  /// Save decks to JSON file
  Future<void> saveDecks(List<Deck> decks) async {
    try {
      final file = await _localFile;
      final jsonData = decks.map((deck) => deck.toJson()).toList();
      final content = const JsonEncoder.withIndent('  ').convert(jsonData);
      await file.writeAsString(content);
    } catch (e) {
      print('Error saving decks: $e');
    }
  }

  /// Add a new deck and save
  Future<void> addDeck(Deck deck, List<Deck> currentDecks) async {
    currentDecks.add(deck);
    await saveDecks(currentDecks);
  }

  /// Remove a deck and save
  Future<void> removeDeck(String deckId, List<Deck> currentDecks) async {
    currentDecks.removeWhere((deck) => deck.id == deckId);
    await saveDecks(currentDecks);
  }

  /// Update a deck and save
  Future<void> updateDeck(Deck updatedDeck, List<Deck> currentDecks) async {
    final index = currentDecks.indexWhere((deck) => deck.id == updatedDeck.id);
    if (index != -1) {
      currentDecks[index] = updatedDeck;
      await saveDecks(currentDecks);
    }
  }
}
