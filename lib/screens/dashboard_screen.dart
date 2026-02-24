import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/note_provider.dart';
import '../models/note_model.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String searchQuery = '';
  int _currentNavIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.note_outlined},
    {'label': 'Work', 'icon': Icons.work_outline},
    {'label': 'Personal', 'icon': Icons.person_outline},
    {'label': 'Ideas', 'icon': Icons.lightbulb_outline},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NoteProvider>(context, listen: false).loadNotes(),
    );
  }

  List<Note> _getDisplayNotes(NoteProvider provider) {
    List<Note> notes = provider.filteredNotes;
    if (searchQuery.isNotEmpty) {
      notes = notes
          .where((n) =>
              n.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              n.description.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return notes;
  }

  void _navigateToAddNote({String? category}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddEditNoteScreen(defaultCategory: category),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final notesToShow = _getDisplayNotes(noteProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildBody(noteProvider, notesToShow),
      ),
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody(NoteProvider noteProvider, List<Note> notesToShow) {
    switch (_currentNavIndex) {
      case 1:
        return _buildSearchPage(noteProvider);
      case 2:
        return _buildStarredPage(noteProvider);
      case 3:
        return _buildAccountPage();
      default:
        return _buildNotesPage(noteProvider, notesToShow);
    }
  }

  // ─── NOTES PAGE (Main) ───────────────────────────────────────
  Widget _buildNotesPage(NoteProvider noteProvider, List<Note> notesToShow) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildWelcomeHeader()),
        SliverToBoxAdapter(child: _buildSearchBar()),
        SliverToBoxAdapter(child: _buildCategoryChips(noteProvider)),
        SliverToBoxAdapter(child: _buildSectionHeader('Recent Notes')),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: _buildNotesGrid(notesToShow, noteProvider),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  // ─── WELCOME HEADER ──────────────────────────────────────────
  Widget _buildWelcomeHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WELCOME BACK,',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'User',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Settings
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
              onPressed: () => _showSettingsSheet(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ──────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          style: GoogleFonts.inter(color: Colors.black, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search your library...',
            hintStyle: GoogleFonts.inter(color: const Color(0xFF888888), fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF555555), size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ─── CATEGORY CHIPS ──────────────────────────────────────────
  Widget _buildCategoryChips(NoteProvider noteProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 0, 4),
      child: SizedBox(
        height: 44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final isSelected = noteProvider.selectedCategory == cat['label'];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => noteProvider.setCategory(cat['label']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.black,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cat['icon'] as IconData,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── SECTION HEADER ──────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          Text(
            'View all',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ─── NOTES GRID ──────────────────────────────────────────────
  Widget _buildNotesGrid(List<Note> notes, NoteProvider noteProvider) {
    final itemCount = notes.length + 1;
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.78,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index < notes.length) {
            final note = notes[index];
            final actualIndex = noteProvider.notes.indexOf(note);
            return NoteCard(
              note: note,
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AddEditNoteScreen(
                      index: actualIndex,
                      existingNote: note,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              onDelete: () => noteProvider.deleteNote(actualIndex),
            );
          } else {
            return _buildCreateNoteCard();
          }
        },
        childCount: itemCount,
      ),
    );
  }

  // ─── CREATE NOTE CARD ────────────────────────────────────────
  Widget _buildCreateNoteCard() {
    return GestureDetector(
      onTap: () => _navigateToAddNote(),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: Colors.black38,
          borderRadius: 18,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                'Create Note',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── FAB ─────────────────────────────────────────────────────
  Widget _buildFAB() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => _navigateToAddNote(),
        child: const Icon(Icons.edit_outlined, color: Colors.white, size: 24),
      ),
    );
  }

  // ─── BOTTOM NAV (no animation) ─────────────────────────────
  Widget _buildBottomNav() {
    const items = [
      {'icon': Icons.sticky_note_2_outlined, 'activeIcon': Icons.sticky_note_2, 'label': 'NOTES'},
      {'icon': Icons.search, 'activeIcon': Icons.search, 'label': 'SEARCH'},
      {'icon': Icons.star_outline, 'activeIcon': Icons.star, 'label': 'STARRED'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'ACCOUNT'},
    ];

    return Container(
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = _currentNavIndex == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _currentNavIndex = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.grey[500],
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ─── SEARCH PAGE ─────────────────────────────────────────────
  Widget _buildSearchPage(NoteProvider noteProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Search', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          if (searchQuery.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Search your notes', style: GoogleFonts.inter(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: _buildSearchResults(noteProvider),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(NoteProvider noteProvider) {
    final searchResults = noteProvider.notes
        .where((n) =>
            n.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            n.description.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (searchResults.isEmpty) {
      return Center(
        child: Text('No results found', style: GoogleFonts.inter(color: Colors.black54)),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final note = searchResults[index];
        final actualIndex = noteProvider.notes.indexOf(note);
        return _buildNoteListTile(note, actualIndex);
      },
    );
  }

  // ─── STARRED PAGE ────────────────────────────────────────────
  Widget _buildStarredPage(NoteProvider noteProvider) {
    final starred = noteProvider.starredNotes;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Starred', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 16),
          if (starred.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No starred notes', style: GoogleFonts.inter(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: starred.length,
                itemBuilder: (context, index) {
                  final note = starred[index];
                  final actualIndex = noteProvider.notes.indexOf(note);
                  return _buildNoteListTile(note, actualIndex);
                },
              ),
            ),
        ],
      ),
    );
  }

  // ─── ACCOUNT PAGE ───────────────────────────────────────────
  Widget _buildAccountPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Account', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 32),
          // Profile card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.person, color: Colors.black, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('user@notetrack.app', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[400])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _buildAccountOption(Icons.dark_mode_outlined, 'Dark Mode', onTap: () {}),
          _buildAccountOption(Icons.notifications_outlined, 'Notifications', onTap: () {}),
          _buildAccountOption(Icons.help_outline, 'Help & Support', onTap: () {}),
          const SizedBox(height: 8),
          _buildAccountOption(Icons.logout, 'Log Out', isDestructive: true, onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAccountOption(IconData icon, String label, {bool isDestructive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? const Color(0xFFEF5350) : Colors.white),
        title: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: isDestructive ? const Color(0xFFEF5350) : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.black,
        onTap: onTap,
      ),
    );
  }

  // ─── SHARED: Note list tile ──────────────────────────────────
  Widget _buildNoteListTile(Note note, int actualIndex) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          note.title.isEmpty ? 'Untitled' : note.title,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            note.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400]),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            note.isStarred ? Icons.star : Icons.star_outline,
            color: note.isStarred ? Colors.white : Colors.grey[500],
            size: 22,
          ),
          onPressed: () => noteProvider.toggleStar(actualIndex),
        ),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AddEditNoteScreen(
                index: actualIndex,
                existingNote: note,
              ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
      ),
    );
  }


  // ─── SETTINGS SHEET ──────────────────────────────────────────
  void _showSettingsSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Settings',
      barrierColor: Colors.black54,
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.black,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: Colors.white),
                    title: Text('Profile', style: GoogleFonts.inter(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.white),
                    title: Text('About', style: GoogleFonts.inter(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Color(0xFFEF5350)),
                    title: Text('Logout', style: GoogleFonts.inter(color: const Color(0xFFEF5350))),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── DASHED BORDER PAINTER ───────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    const dashWidth = 8.0;
    const dashSpace = 5.0;
    double distance = 0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end.clamp(0, metric.length)),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}