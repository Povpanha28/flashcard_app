import 'dart:convert';
import 'package:flashcard_app/models/deck.dart';
import 'package:shared_preferences/shared_preferences.dart';


// AI GENERATED - Data repository for managing flashcard decks
class DataRepository {
  static const String _decksKey = 'flashcard_decks';

  // Singleton pattern
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  List<Deck> _decks = [];

  List<Deck> get decks => _decks;

  /// Initialize the repository by loading data from storage
  Future<void> init() async {
    await loadDecks();
  }

  /// Load decks from JSON storage
  Future<List<Deck>> loadDecks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_decksKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _decks = jsonList
            .map((json) => Deck.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        _decks = [];
      }
    } catch (e) {
      print('Error loading decks: $e');
      _decks = [];
    }
    return _decks;
  }

  /// Save decks to JSON storage
  Future<bool> saveDecks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _decks.map((deck) => deck.toJson()).toList();
      final jsonString = json.encode(jsonList);
      return await prefs.setString(_decksKey, jsonString);
    } catch (e) {
      print('Error saving decks: $e');
      return false;
    }
  }

  /// Add a new deck and save
  Future<void> addDeck(Deck deck) async {
    _decks.add(deck);
    await saveDecks();
  }

  /// Update an existing deck and save
  Future<void> updateDeck(Deck updatedDeck) async {
    final index = _decks.indexWhere((d) => d.id == updatedDeck.id);
    if (index != -1) {
      _decks[index] = updatedDeck;
      await saveDecks();
    }
  }

  /// Delete a deck and save
  Future<void> deleteDeck(String deckId) async {
    _decks.removeWhere((d) => d.id == deckId);
    await saveDecks();
  }

  /// Get a deck by ID
  Deck? getDeckById(String id) {
    try {
      return _decks.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    _decks = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_decksKey);
  }
}


