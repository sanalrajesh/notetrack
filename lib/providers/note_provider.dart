import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/hive_service.dart';

class NoteProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<Note> _notes = [];
  String _selectedCategory = 'All';

  List<Note> get notes => _notes;
  String get selectedCategory => _selectedCategory;

  List<Note> get filteredNotes {
    if (_selectedCategory == 'All') return _notes;
    return _notes.where((n) => n.category.toUpperCase() == _selectedCategory.toUpperCase()).toList();
  }

  List<Note> get starredNotes => _notes.where((n) => n.isStarred).toList();

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void loadNotes() {
    _notes = _hiveService.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _hiveService.addNote(note);
    loadNotes();
  }

  Future<void> deleteNote(int index) async {
    await _hiveService.deleteNote(index);
    loadNotes();
  }

  Future<void> updateNote(int index, Note note) async {
    await _hiveService.updateNote(index, note);
    loadNotes();
  }

  Future<void> toggleStar(int index) async {
    final note = _notes[index];
    note.isStarred = !note.isStarred;
    await _hiveService.updateNote(index, note);
    loadNotes();
  }
}