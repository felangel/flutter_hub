import 'package:equatable/equatable.dart';

import 'package:github_repository/github_repository.dart';

abstract class GithubSearchState extends Equatable {
  GithubSearchState([List props = const []]) : super(props);
}

class SearchStateLoading extends GithubSearchState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends GithubSearchState {
  final List<SearchResultItem> items;

  SearchStateSuccess(this.items) : super([items]);

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends GithubSearchState {
  final String error;

  SearchStateError(this.error) : super([error]);

  @override
  String toString() => 'SearchStateError';
}
