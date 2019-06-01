import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:github_repository/github_repository.dart';
import 'package:flutter_hub/github_search_bloc/bloc.dart';

class GithubSearchBloc extends Bloc<GithubSearchEvent, GithubSearchState> {
  final GithubRepository githubRepository;

  GithubSearchBloc({@required this.githubRepository});

  @override
  Stream<GithubSearchState> transform(
    Stream<GithubSearchEvent> events,
    Stream<GithubSearchState> Function(GithubSearchEvent event) next,
  ) {
    return super.transform(
      (events as Observable<GithubSearchEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  void onTransition(
    Transition<GithubSearchEvent, GithubSearchState> transition,
  ) {
    print(transition);
  }

  @override
  GithubSearchState get initialState => SearchStateLoading();

  @override
  Stream<GithubSearchState> mapEventToState(GithubSearchEvent event) async* {
    if (event is ProjectTextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        dispatch(FetchInitialProjects());
      } else {
        yield SearchStateLoading();
        try {
          final results = await githubRepository.searchProjects(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    } else if (event is FetchInitialProjects) {
      yield SearchStateLoading();
      try {
        final results = await githubRepository.searchProjects('');
        yield SearchStateSuccess(results.items);
      } catch (error) {
        yield error is SearchResultError
            ? SearchStateError(error.message)
            : SearchStateError('something went wrong');
      }
    } else if (event is ProfileTextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        dispatch(FetchInitialProfiles());
      } else {
        yield SearchStateLoading();
        try {
          final results = await githubRepository.searchProfiles(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    } else if (event is FetchInitialProfiles) {
      yield SearchStateLoading();
      try {
        final results = await githubRepository.searchProfiles('');
        yield SearchStateSuccess(results.items);
      } catch (error) {
        yield error is SearchResultError
            ? SearchStateError(error.message)
            : SearchStateError('something went wrong');
      }
    }
  }
}
