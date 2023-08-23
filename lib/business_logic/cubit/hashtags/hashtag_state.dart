part of 'hashtag_cubit.dart';

@immutable
abstract class HashtagState {
  const HashtagState();
}

class HashtagInitial extends HashtagState {}

class GettingAllHashTags extends HashtagState {}

class HashTagsGotten extends HashtagState {
  final List<HashTag> hashTags;
  final List<HashTag> hashTagsFiltered;

  const HashTagsGotten(
      {required this.hashTags, required this.hashTagsFiltered});
}

class GettingAllHashTagsFailed extends HashtagState {
  final String error;

  const GettingAllHashTagsFailed({required this.error});
}

class GettingAllHashNewTags extends HashtagState {}

class HashTagsNewGotten extends HashtagState {
  final List<HashTag> hashTags;
  final List<HashTag> hashTagsFiltered;

  const HashTagsNewGotten(
      {required this.hashTags, required this.hashTagsFiltered});
}

class GettingAllHashTagsNewFailed extends HashtagState {
  final String error;

  const GettingAllHashTagsNewFailed({required this.error});
}

class AddingHashTag extends HashtagState {}

class HashTagsAdded extends HashtagState {}

class AddingHashTagFailed extends HashtagState {
  final String error;

  const AddingHashTagFailed({required this.error});
}

class DeletingHashTag extends HashtagState {}

class HashTagsDeleted extends HashtagState {}

class DeletingHashTagFailed extends HashtagState {
  final String error;

  const DeletingHashTagFailed({required this.error});
}
