import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/note_model.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notesBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const NoteTrackApp(),
    ),
  );
}

class NoteTrackApp extends StatelessWidget {
  const NoteTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteTrack',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      themeMode: themeProvider.currentTheme,
      home: const LoginScreen(),
    );
  }
}