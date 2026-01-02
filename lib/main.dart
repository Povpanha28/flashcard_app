import 'package:flutter/material.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/welcome.dart';

void main() {
  runApp(const FlashLearnApp());
}

class FlashLearnApp extends StatelessWidget {
  const FlashLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashLearn',
      theme: AppTheme.lightTheme,
      home:  Welcome(),
    );
  }
}
