part of 'hashtag_cubit.dart';

@immutable
abstract class HashtagState {
  const HashtagState();
}

class HashtagInitial extends HashtagState {}

class GettingAllHashTags extends HashtagState {}

class HashTagsGotten extends HashtagState {
  final List<HashTag> hashTags;

  const HashTagsGotten({required this.hashTags});
}

class GettingAllHashTagsFailed extends HashtagState {
  final String error;

  const GettingAllHashTagsFailed({required this.error});
}

class AddingHashTag extends HashtagState {}

class HashTagsAdded extends HashtagState {}

class AddingHashTagFailed extends HashtagState {
  final String error;

  const AddingHashTagFailed({required this.error});
}
