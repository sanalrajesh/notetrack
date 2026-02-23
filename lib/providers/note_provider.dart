import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/hive_service.dart';

class NoteProvider extends ChangeNotifier {
  final HiveService _hiveService = HiveService();

  List<Note> _notes = [];

  List<Note> get notes => _notes;


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
}