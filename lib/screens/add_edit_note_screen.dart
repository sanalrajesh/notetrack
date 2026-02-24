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

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final noteProvider =
          Provider.of<NoteProvider>(context, listen: false);

      final note = Note(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        subject: _subjectController.text.trim(),
        createdAt:
            widget.existingNote?.createdAt ?? DateTime.now(),
      );

      if (isEditing) {
        await noteProvider.updateNote(widget.index!, note);
      } else {
        await noteProvider.addNote(note);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Note' : 'Add Note',
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _saveNote,
            icon: const Icon(Icons.check, size: 28),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.subject),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter subject' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Note Title',
                  hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter title' : null,
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _descController,
                maxLines: null,
                style: GoogleFonts.poppins(fontSize: 16),
                decoration: InputDecoration(
                  hintText:
                      'Start typing your note here...',
                  hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
                validator: (value) =>
                    value!.isEmpty
                        ? 'Enter description'
                        : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}