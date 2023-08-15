import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import '../../../data/models/note.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  void addNote(Note note) {
    try {
      emit(AddingNote());
      final Box notesBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(notesBox.get("notesList", defaultValue: []))
              .cast<Note>();
      notesList.add(note);
      notesBox.put("notesList", notesList);
      emit(NotesAdded());
      getNotes();
    } catch (e) {
      emit(AddingNoteFailed(error: "Error: $e"));
    }
  }

  void getNotes() {
    try {
      emit(GettingAllNotes());
      final Box noteBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(noteBox.get("notesList", defaultValue: []))
              .cast<Note>();
      emit(NotesGotten(notes: notesList, notesFiltered: notesList));
    } catch (e) {
      emit(GettingAllNotesFailed(error: "Error: $e"));
    }
  }

  void getFilteredNotesByHashTag(String hashTag) {
    try {
      emit(GettingAllNotes());
      final Box noteBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(noteBox.get("notesList", defaultValue: []))
              .cast<Note>();
      late List<Note> filteredList;
      if (hashTag == "id") {
        filteredList = notesList;
      } else {
        filteredList = notesList
            .where((note) => note.hashtagsId.contains(hashTag))
            .toList();
      }
      emit(NotesGotten(notes: notesList, notesFiltered: filteredList));
    } catch (e) {
      emit(GettingAllNotesFailed(error: "Error: $e"));
    }
  }

  void getFilteredNotesByResearch(String keyword) {
    try {
      emit(GettingAllNotes());
      final Box noteBox = Hive.box("Notes");
      List<Note> notesList =
          List.castFrom(noteBox.get("notesList", defaultValue: []))
              .cast<Note>();
      List<Note> filteredList = notesList
          .where((note) =>
              note.title.toLowerCase().contains(keyword) ||
              note.note.toLowerCase().contains(keyword))
          .toList();
      emit(NotesGotten(notes: notesList, notesFiltered: filteredList));
    } catch (e) {
      emit(GettingAllNotesFailed(error: "Error: $e"));
    }
  }
}
