import 'package:flashcard_app/data/data_repostiy.dart';
import 'package:flashcard_app/ui/screens/decks/decks.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataRepository().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Decks()),
    );
  }
}
