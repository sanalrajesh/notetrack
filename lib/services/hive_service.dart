import 'package:hive/hive.dart';
import '../models/note_model.dart';

class HiveService {
  final Box<Note> _noteBox = Hive.box<Note>('notesBox');

  List<Note> getNotes() {
    return _noteBox.values.toList();
  }

  Future<void> addNote(Note note) async {
    await _noteBox.add(note);
  }

  Future<void> deleteNote(int index) async {
    await _noteBox.deleteAt(index);
  }

  Future<void> updateNote(int index, Note note) async {
    await _noteBox.putAt(index, note);
  }
}