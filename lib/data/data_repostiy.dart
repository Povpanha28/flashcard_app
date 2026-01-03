import 'dart:convert';
import 'package:flashcard_app/models/deck.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data repository for managing flashcard decks using SharedPreferences
class DataRepository {
  static const String _prefsKey = 'flashcard_decks_data';

  // Singleton pattern
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal();

  List<Deck> _decks = [];
  bool _isInitialized = false;

  List<Deck> get decks => _decks;
  bool get isInitialized => _isInitialized;

  /// Initialize the repository by loading data from SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;
    await loadDecks();
    _isInitialized = true;
    print('DataRepository initialized with ${_decks.length} decks');
  }

  /// Load decks from SharedPreferences
  Future<List<Deck>> loadDecks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);

      print('Loading from SharedPreferences...');
      print('Raw data: $jsonString');

      if (jsonString != null && jsonString.isNotEmpty) {
        final decoded = json.decode(jsonString);
        if (decoded is List && decoded.isNotEmpty) {
          _decks = decoded
              .map((item) => Deck.fromJson(item as Map<String, dynamic>))
              .toList();
          print('Successfully loaded ${_decks.length} decks');
        } else {
          _decks = [];
          print('Data was empty array, starting fresh');
        }
      } else {
        _decks = [];
        print('No data found in SharedPreferences, starting fresh');
      }
    } catch (e) {
      print('Error loading decks: $e');
      _decks = [];
    }
    return _decks;
  }

  /// Save decks to SharedPreferences
  /// This is called automatically after any modification to ensure real-time persistence
  Future<bool> saveDecks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _decks.map((deck) => deck.toJson()).toList();
      final jsonString = json.encode(jsonList);

      print('Saving ${_decks.length} decks to SharedPreferences...');
      print('Data to save: $jsonString');

      final result = await prefs.setString(_prefsKey, jsonString);

      if (result) {
        print('Successfully saved ${_decks.length} decks');
      } else {
        print('Failed to save to SharedPreferences');
      }

      return result;
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

  /// Add a card to a deck and save immediately
  Future<void> addCardToDeck(String deckId, dynamic card) async {
    final deck = getDeckById(deckId);
    if (deck != null) {
      deck.addCard(card);
      await saveDecks();
    }
  }

  /// Update a card in a deck and save immediately
  Future<void> updateCardInDeck(
    String deckId,
    String cardId,
    dynamic updatedCard,
  ) async {
    final deck = getDeckById(deckId);
    if (deck != null) {
      deck.updateFlashcard(cardId, updatedCard);
      await saveDecks();
    }
  }

  /// Remove a card from a deck and save immediately
  Future<void> removeCardFromDeck(String deckId, String cardId) async {
    final deck = getDeckById(deckId);
    if (deck != null) {
      deck.removeCard(cardId);
      await saveDecks();
    }
  }

  /// Force save - useful for ensuring data is persisted
  Future<bool> forceSave() async {
    return await saveDecks();
  }

  /// Clear all data
  Future<void> clearAll() async {
    _decks = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    print('Cleared all data');
  }
}
