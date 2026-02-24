import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [

          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.indigo,
              ),
            ),
            onSelected: (value) {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              if (value == 'profile') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile clicked")),
                );
              } else if (value == 'theme') {
                themeProvider.toggleTheme(); 
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              const PopupMenuItem(
                value: 'theme',
                child: Text('Theme Mode'),
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: noteProvider.notes.isEmpty
          ? const Center(
              child: Text(
                "No Notes Yet",
                style: TextStyle(fontSize: 16),
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