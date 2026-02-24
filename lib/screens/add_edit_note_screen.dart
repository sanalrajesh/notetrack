import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? existingNote;
  final int? index;
  final String? defaultCategory;

  const AddEditNoteScreen({
    super.key,
    this.existingNote,
    this.index,
    this.defaultCategory,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _subjectController;
  late String _selectedCategory;

  static const _bgColor = Color(0xFF0A0E21);
  static const _surfaceColor = Color(0xFF141829);
  static const _accentBlue = Color(0xFF1E88E5);

  final List<String> _categories = ['IDEAS', 'WORK', 'PERSONAL'];

  bool get isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingNote?.title ?? '');
    _descController = TextEditingController(text: widget.existingNote?.description ?? '');
    _subjectController = TextEditingController(text: widget.existingNote?.subject ?? '');
    _selectedCategory = widget.existingNote?.category ?? widget.defaultCategory ?? 'IDEAS';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Color _categoryColor(String cat) {
    switch (cat.toUpperCase()) {
      case 'WORK':
        return _accentBlue;
      case 'PERSONAL':
        return const Color(0xFFE91E63);
      case 'IDEAS':
      default:
        return const Color(0xFF4CAF50);
    }
  }

  Future<void> _saveNote() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (_titleController.text.trim().isEmpty &&
        _descController.text.trim().isEmpty &&
        _subjectController.text.trim().isEmpty) {
      return;
    }

    final note = Note(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      subject: _subjectController.text.trim(),
      createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
      category: _selectedCategory,
      isStarred: widget.existingNote?.isStarred ?? false,
    );

    if (isEditing) {
      await noteProvider.updateNote(widget.index!, note);
    } else {
      await noteProvider.addNote(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveNote();
        return true;
      },
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
            ),
            onPressed: () async {
              await _saveNote();
              if (context.mounted) Navigator.pop(context);
            },
          ),
          title: Text(
            isEditing ? 'Edit Note' : 'New Note',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: () async {
                  await _saveNote();
                  if (context.mounted) Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: _accentBlue.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                    color: _accentBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Category picker
                Text(
                  'Category',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    final color = _categoryColor(cat);
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? color.withOpacity(0.2) : _surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? color : Colors.white.withOpacity(0.06),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? color : Colors.grey[500],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Subject field
                Container(
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: TextFormField(
                    controller: _subjectController,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      labelStyle: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      prefixIcon: Icon(Icons.subject, color: Colors.grey[600], size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title field
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    hintStyle: GoogleFonts.inter(
                      color: Colors.grey[700],
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 8),

                // Divider
                Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.04),
                ),
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  controller: _descController,
                  maxLines: null,
                  minLines: 12,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.grey[300],
                    height: 1.7,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Start typing your note here...',
                    hintStyle: GoogleFonts.inter(
                      color: Colors.grey[700],
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}