import 'package:reddit_repository/reddit_repository.dart';

abstract class RedditSearchState {}

class SearchStateLoading extends RedditSearchState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends RedditSearchState {
  final List<Article> items;
  final bool hasReachedMax;

  SearchStateSuccess(this.items, this.hasReachedMax);

  @override
  String toString() =>
      'SearchStateSuccess { items: ${items.length}, hasReachedMax: $hasReachedMax }';
}

class SearchStateError extends RedditSearchState {
  final String error;

  SearchStateError(this.error);

  @override
  String toString() => 'SearchStateError';
}
