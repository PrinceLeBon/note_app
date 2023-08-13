import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import '../../../data/models/hashtag.dart';

part 'hashtag_state.dart';

class HashtagCubit extends Cubit<HashtagState> {
  HashtagCubit() : super(HashtagInitial());

  void addHashTag(HashTag hashTag, List<HashTag> hashTagsList) {
    try {
      emit(AddingHashTag());
      final Box noteBox = Hive.box("Note");
      hashTagsList.add(hashTag);
      noteBox.put("hashTagsList", hashTagsList);
      emit(HashTagsAdded());
    } catch (e) {
      emit(AddingHashTagFailed(error: "Error: $e"));
    }
  }

  void getHashTags() {
    try {
      emit(GettingAllHashTags());
      final Box noteBox = Hive.box("Notes");
      List<HashTag> hashTagsList =
          List.castFrom(noteBox.get("hashTagsList", defaultValue: []))
              .cast<HashTag>();
      emit(HashTagsGotten(hashTags: hashTagsList));
    } catch (e) {
      emit(GettingAllHashTagsFailed(error: "Error: $e"));
    }
  }
}
