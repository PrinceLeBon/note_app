part of 'note_cubit.dart';

@immutable
abstract class NoteState {
  const NoteState();
}

class NoteInitial extends NoteState {}

class GettingAllNotes extends NoteState {}

class NotesGotten extends NoteState {
  final List<Note> notes;
  final List<Note> notesFiltered;

  const NotesGotten({required this.notes, required this.notesFiltered});
}

class GettingAllNotesFailed extends NoteState {
  final String error;

  const GettingAllNotesFailed({required this.error});
}

class AddingNote extends NoteState {}

class NotesAdded extends NoteState {}

class AddingNoteFailed extends NoteState {
  final String error;

  const AddingNoteFailed({required this.error});
}
