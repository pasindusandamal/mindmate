import 'package:flutter/material.dart';
import 'screens/chatbot_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chatbot',
      theme: AppTheme.lightTheme,
      home: const ChatbotScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}