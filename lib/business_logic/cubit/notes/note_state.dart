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

class DeletingNote extends NoteState {}

class NotesDeleted extends NoteState {}

class DeletingNoteFailed extends NoteState {
  final String error;

  const DeletingNoteFailed({required this.error});
}

class UpdatingNote extends NoteState {}

class NoteUpdated extends NoteState {}

class UpdatingNoteFailed extends NoteState {
  final String error;

  const UpdatingNoteFailed({required this.error});
}
