import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:github_repository/github_repository.dart';
import 'package:flutter_hub/project_search/bloc/bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GithubRepository githubRepository;

  SearchBloc({@required this.githubRepository});

  @override
  Stream<SearchState> transform(
    Stream<SearchEvent> events,
    Stream<SearchState> Function(SearchEvent event) next,
  ) {
    return super.transform(
      (events as Observable<SearchEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  void onTransition(
    Transition<SearchEvent, SearchState> transition,
  ) {
    print(transition);
  }

  @override
  SearchState get initialState => SearchStateLoading();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is TextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        dispatch(FetchInitial());
      } else {
        yield SearchStateLoading();
        try {
          final results = await githubRepository.search(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    } else if (event is FetchInitial) {
      yield SearchStateLoading();
      try {
        final results = await githubRepository.search('');
        yield SearchStateSuccess(results.items);
      } catch (error) {
        yield error is SearchResultError
            ? SearchStateError(error.message)
            : SearchStateError('something went wrong');
      }
    }
  }
}
