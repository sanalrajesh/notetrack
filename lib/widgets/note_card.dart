import 'package:flutter/material.dart';
import '../models/note_model.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDarkMode; // new

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? const Color.fromARGB(255, 15, 15, 15) : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final titleColor = isDarkMode ? const Color.fromARGB(255, 247, 249, 248) : Colors.black;
    final subjectColor = isDarkMode ? Colors.white : Colors.black;
    final descriptionColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
    final dateColor = isDarkMode ? Colors.grey[500] : Colors.grey[600];

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 165,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.red.withOpacity(0.2),
                    child: Icon(Icons.delete, size: 20, color: dateColor),
                  ),
                ),
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: descriptionColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                note.subject,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: subjectColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(note.createdAt),
                style: TextStyle(fontSize: 11, color: dateColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}