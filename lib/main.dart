import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NoteTrackApp());
}

class NoteTrackApp extends StatelessWidget {
  const NoteTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteTrack',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginScreen(),
    );
  }
}