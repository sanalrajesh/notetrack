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
  String searchQuery = '';
  String selectedFilter = 'All'; // All, Pinned, Completed, High

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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  List filteredNotes(NoteProvider noteProvider) {
    List notes = noteProvider.notes;

    // Filter by search
    if (searchQuery.isNotEmpty) {
      notes = notes
          .where((n) =>
              n.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              n.description.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by chip
    if (selectedFilter == 'Pinned') {
      notes = notes.where((n) => n.isPinned).toList();
    } else if (selectedFilter == 'Completed') {
      notes = notes.where((n) => n.isCompleted).toList();
    } else if (selectedFilter == 'High') {
      notes = notes.where((n) => n.priority == 3).toList();
    }

    return notes;
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final notesToShow = filteredNotes(noteProvider);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:
            isDark ? Colors.black : const Color.fromARGB(255, 254, 255, 255),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.indigo),
        ),
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
        backgroundColor:
            isDark ? const Color.fromARGB(255, 242, 243, 242) : Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoteScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          /// 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: "Search notes...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 Filter Chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                filterChip("All"),
                filterChip("Pinned"),
                filterChip("Completed"),
                filterChip("High"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 GridView Notes
          Expanded(
            child: notesToShow.isEmpty
                ? Center(
                    child: Text(
                      "No Notes Found",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: notesToShow.length,
                    itemBuilder: (context, index) {
                      final note = notesToShow[index];
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
          ),
        ],
      ),
    );
  }

  Widget filterChip(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() {
            selectedFilter = label;
          });
        },
        selectedColor: Colors.indigo,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}