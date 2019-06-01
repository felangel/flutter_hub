import 'package:equatable/equatable.dart';

import 'package:github_repository/jobs_repository.dart';

abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class SearchStateLoading extends SearchState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends SearchState {
  final List<SearchResultItem> items;

  SearchStateSuccess(this.items) : super([items]);

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends SearchState {
  final String error;

  SearchStateError(this.error) : super([error]);

  @override
  String toString() => 'SearchStateError';
}
