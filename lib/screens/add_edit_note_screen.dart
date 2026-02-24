import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? existingNote;
  final int? index;

  const AddEditNoteScreen({
    super.key,
    this.existingNote,
    this.index,
  });

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _subjectController;

  bool get isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.existingNote?.title ?? '');
    _descController =
        TextEditingController(text: widget.existingNote?.description ?? '');
    _subjectController =
        TextEditingController(text: widget.existingNote?.subject ?? '');
  }

  /// Save note method
  Future<void> _saveNote() async {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    // Skip saving completely empty notes
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
        await _saveNote(); // Auto-save before leaving
        return true; // Allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? 'Edit Note' : 'Add Note',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Subject Field
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.subject),
                  ),
                ),
                const SizedBox(height: 16),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 8),

                // Description Field
                TextFormField(
                  controller: _descController,
                  maxLines: null,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Start typing your note here...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
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