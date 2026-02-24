import 'package:flutter/material.dart';
import 'package:notetrack/screens/login_screen.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart'; 
import 'add_edit_note_screen.dart';
import '../widgets/note_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NoteProvider>(context, listen: false).loadNotes(),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Theme Mode"),
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginScreen()) 
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  final noteProvider = Provider.of<NoteProvider>(context);
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDark = themeProvider.isDarkMode;

  return Scaffold(
    backgroundColor: isDark ? Colors.black : Colors.white, // entire background changes
    appBar: AppBar(
      backgroundColor: isDark ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 254, 255, 255),
      title: const Text("Dashboard"),
      actions: [
        GestureDetector(
          onTap: () => _showProfileMenu(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.indigo,
              ),
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: isDark ? const Color.fromARGB(255, 242, 243, 242) : const Color.fromARGB(255, 247, 248, 248),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddEditNoteScreen(),
          ),
        );
      },
      child: const Icon(Icons.add,color: Colors.black,),
    ),
    body: noteProvider.notes.isEmpty
        ? Center(
            child: Text(
              "No Notes Yet",
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: noteProvider.notes.length,
            itemBuilder: (context, index) {
              final note = noteProvider.notes[index];
              return NoteCard(
                note: note,
                isDarkMode: isDark, // pass the theme to NoteCard
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditNoteScreen(
                        index: index,
                        existingNote: note,
                      ),
                    ),
                  );
                },
                onDelete: () {
                  noteProvider.deleteNote(index);
                },
              );
            },
          ),
  );
}
}