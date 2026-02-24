import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDarkMode;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    this.isDarkMode = true,
  });

  Color _categoryColor() {
    switch (note.category.toUpperCase()) {
      case 'WORK':
        return const Color(0xFF1E88E5);
      case 'PERSONAL':
        return const Color(0xFFE91E63);
      case 'IDEAS':
      default:
        return const Color(0xFF4CAF50);
    }
  }

  String _relativeTime() {
    final now = DateTime.now();
    final diff = now.difference(note.createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[note.createdAt.month - 1]} ${note.createdAt.day}';
  }

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFF1A1F38);
    final catColor = _categoryColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: category badge + menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    note.category.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: catColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  color: const Color(0xFF232847),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16, color: Colors.grey[400]),
                          const SizedBox(width: 8),
                          Text('Edit', style: GoogleFonts.inter(color: Colors.grey[300], fontSize: 13)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 16, color: Color(0xFFEF5350)),
                          const SizedBox(width: 8),
                          Text('Delete', style: GoogleFonts.inter(color: const Color(0xFFEF5350), fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      onTap();
                    } else if (value == 'delete') {
                      onDelete();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              note.title.isEmpty ? 'Untitled' : note.title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Description
            Expanded(
              child: Text(
                note.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Time
            Text(
              _relativeTime(),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}