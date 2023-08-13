import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import '../../../data/models/hashtag.dart';

part 'hashtag_state.dart';

class HashtagCubit extends Cubit<HashtagState> {
  HashtagCubit() : super(HashtagInitial());

  void addHashTag(HashTag hashTag, List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered) {
    try {
      emit(AddingHashTag());
      final Box noteBox = Hive.box("Notes");
      hashTagsList.add(hashTag);
      noteBox.put("hashTagsList", hashTagsList);
      emit(HashTagsAdded());
      getHashTags(hashTagsListFiltered);
    } catch (e) {
      emit(AddingHashTagFailed(error: "Error: $e"));
    }
  }

  void deleteHashTag(int index, List<HashTag> hashTagsList) {
    try {
      emit(DeletingHashTag());
      final Box noteBox = Hive.box("Notes");
      hashTagsList.removeAt(index);
      noteBox.put("hashTagsList", hashTagsList);
      emit(HashTagsDeleted());
      getHashTags();
    } catch (e) {
      emit(DeletingHashTagFailed(error: "Error: $e"));
    }
  }

  void deleteHashTagFiltered(int index, List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered) {
    try {
      emit(GettingAllHashTags());
      hashTagsListFiltered.removeAt(index);
      emit(HashTagsGotten(
          hashTags: hashTagsList, hashTagsFiltered: hashTagsListFiltered));
    } catch (e) {
      emit(GettingAllHashTagsFailed(error: "Error: $e"));
    }
  }

  void addFilteredChoice(List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered, String label) {
    try {
      emit(GettingAllHashTags());

      if (hashTagsListFiltered
          .where((element) => element.label == label)
          .toList()
          .isEmpty) {
        hashTagsListFiltered.add(hashTagsList
            .where((element) => element.label == label)
            .toList()[0]);
      }

      emit(HashTagsGotten(
          hashTags: hashTagsList, hashTagsFiltered: hashTagsListFiltered));
    } catch (e) {
      emit(GettingAllHashTagsFailed(error: "Error: $e"));
    }
  }

  void getHashTags([List<HashTag>? hashTagsListFiltered]) {
    try {
      emit(GettingAllHashTags());
      final Box noteBox = Hive.box("Notes");
      List<HashTag> hashTagsList =
          List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
              .cast<HashTag>();
      emit(HashTagsGotten(
          hashTags: hashTagsList,
          hashTagsFiltered: hashTagsListFiltered ?? []));
    } catch (e) {
      emit(GettingAllHashTagsFailed(error: "Error: $e"));
    }
  }
}
