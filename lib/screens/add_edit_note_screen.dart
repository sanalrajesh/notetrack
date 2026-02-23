import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final int? index;
  final Note? existingNote;

  const AddEditNoteScreen({super.key, this.index, this.existingNote});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _subjectController;

  bool get isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();

    _titleController =
        TextEditingController(text: widget.existingNote?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.existingNote?.description ?? '');
    _subjectController =
        TextEditingController(text: widget.existingNote?.subject ?? '');
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final noteProvider =
          Provider.of<NoteProvider>(context, listen: false);

      final note = Note(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        subject: _subjectController.text.trim(),
        createdAt: DateTime.now(),
      );

      if (isEditing) {
        await noteProvider.updateNote(widget.index!, note);
      } else {
        await noteProvider.addNote(note);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Note" : "Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter subject" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(isEditing ? "Update Note" : "Save Note"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}