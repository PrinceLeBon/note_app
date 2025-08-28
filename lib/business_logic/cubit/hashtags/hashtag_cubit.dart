import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import '../../../data/models/hashtag.dart';
import '../../../data/repositories/hashtag.dart';

part 'hashtag_state.dart';

class HashtagCubit extends Cubit<HashtagState> {
  final HashTagRepository hashTagRepository;

  HashtagCubit({required this.hashTagRepository}) : super(HashtagInitial());

  Future<void> addHashTag(HashTag hashTag, List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered) async {
    try {
      emit(AddingHashTag());
      await hashTagRepository.addDocs(hashTag);
      final Box noteBox = Hive.box("Notes");
      hashTagsList.add(hashTag);
      noteBox.put("hashTagsList", hashTagsList);
      emit(HashTagsAdded());
      await getHashTags(hashTagsListFiltered);
      getHashTagsNew(hashTagsListFiltered);
      Logger().i("ee");
    } catch (e) {
      emit(AddingHashTagFailed(error: "Error: $e"));
    }
  }

  Future<void> deleteHashTag(String hashTagId) async {
    try {
      emit(CheckingHashTagUsage());
      
      // Check if hashtag is in use
      int usageCount = hashTagRepository.checkHashTagUsage(hashTagId);
      if (usageCount > 0) {
        emit(HashTagInUse(
          message: "Ce hashtag est utilisé dans $usageCount note(s). Vous ne pouvez pas le supprimer.",
          noteCount: usageCount,
        ));
        // Return to previous state after 2 seconds
        await Future.delayed(const Duration(seconds: 2));
        getHashTags();
        return;
      }
      
      emit(DeletingHashTag());
      await hashTagRepository.deleteHashTag(hashTagId);
      emit(HashTagsDeleted());
      getHashTags();
    } catch (e) {
      emit(DeletingHashTagFailed(error: "Error: $e"));
    }
  }

  void deleteHashTagFiltered(int index, List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered) {
    try {
      emit(GettingAllHashNewTags());
      hashTagsListFiltered.removeAt(index);
      emit(HashTagsNewGotten(
          hashTags: hashTagsList, hashTagsFiltered: hashTagsListFiltered));
    } catch (e) {
      emit(GettingAllHashTagsNewFailed(error: "Error: $e"));
    }
  }

  void addFilteredChoice(List<HashTag> hashTagsList,
      List<HashTag> hashTagsListFiltered, String label) {
    try {
      emit(GettingAllHashNewTags());

      if (hashTagsListFiltered
          .where((element) => element.label == label)
          .toList()
          .isEmpty) {
        hashTagsListFiltered.add(hashTagsList
            .where((element) => element.label == label)
            .toList()[0]);
      }

      emit(HashTagsNewGotten(
          hashTags: hashTagsList, hashTagsFiltered: hashTagsListFiltered));
    } catch (e) {
      emit(GettingAllHashTagsNewFailed(error: "Error: $e"));
    }
  }

  Future<void> getHashTags([List<HashTag>? hashTagsListFiltered]) async {
    try {
      emit(GettingAllHashTags());
      /*List<HashTag> hashTagsListFromFiresore =*/
      await hashTagRepository.getAllHashTags();
      final Box noteBox = Hive.box("Notes");
      List<HashTag> hashTagsList =
          List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
              .cast<HashTag>();
      if (hashTagsList.isNotEmpty &&
          hashTagsList.where((hashTag) => hashTag.label == "Tout").isEmpty) {
        hashTagsList.insert(
            0,
            HashTag(
                id: "id",
                label: "Tout",
                color: "#FFFFFF}",
                creationDate: DateTime.now(),
                userId: ""));
      }
      emit(HashTagsGotten(
          hashTags: hashTagsList,
          hashTagsFiltered: hashTagsListFiltered ?? []));
    } catch (e) {
      emit(GettingAllHashTagsFailed(error: "Error: $e"));
    }
  }

  void getHashTagsNew([List<HashTag>? hashTagsListFiltered]) {
    try {
      emit(GettingAllHashNewTags());
      final Box noteBox = Hive.box("Notes");
      List<HashTag> hashTagsList =
          List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
              .cast<HashTag>();
      hashTagsList.removeWhere((hashTag) => hashTag.label == "Tout");
      emit(HashTagsNewGotten(
          hashTags: hashTagsList,
          hashTagsFiltered: hashTagsListFiltered ?? []));
    } catch (e) {
      emit(GettingAllHashTagsNewFailed(error: "Error: $e"));
    }
  }

  void setFilteredHashtags(List<HashTag> filteredHashtags) {
    try {
      if (state is HashTagsNewGotten) {
        final currentState = state as HashTagsNewGotten;
        emit(HashTagsNewGotten(
            hashTags: currentState.hashTags,
            hashTagsFiltered: filteredHashtags));
      }
    } catch (e) {
      Logger().e("Error setting filtered hashtags: $e");
    }
  }

  Future<void> updateHashTag(HashTag hashTag) async {
    try {
      emit(UpdatingHashTag());
      await hashTagRepository.updateHashTag(hashTag);
      emit(HashTagUpdated());
      getHashTags();
    } catch (e) {
      emit(UpdatingHashTagFailed(error: "Error: $e"));
    }
  }
}
