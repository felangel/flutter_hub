import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'package:reddit_repository/reddit_repository.dart';
import 'package:flutter_hub/reddit_search_bloc/bloc.dart';

class RedditSearchBloc extends Bloc<RedditSearchEvent, RedditSearchState> {
  final RedditRepository redditRepository;
  int _count = 0;
  final int _step = 10;

  RedditSearchBloc({@required this.redditRepository});

  @override
  Stream<RedditSearchState> transform(
    Stream<RedditSearchEvent> events,
    Stream<RedditSearchState> Function(RedditSearchEvent event) next,
  ) {
    return super.transform(
      (events as Observable<RedditSearchEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  RedditSearchState get initialState => SearchStateLoading();

  @override
  Stream<RedditSearchState> mapEventToState(RedditSearchEvent event) async* {
    if (event is FetchArticles && !_hasReachedMax(currentState)) {
      try {
        _count += _step;
        final results = await redditRepository.getArticles(_count);
        if (_count >= results.items.length) {
          yield SearchStateSuccess(results.items, true);
        } else {
          yield SearchStateSuccess(results.items, false);
        }
        _count = results.items.length;
      } catch (error) {
        print(error);
        yield SearchStateError('something went wrong');
      }
    }
  }

  bool _hasReachedMax(RedditSearchState state) =>
      state is SearchStateSuccess && state.hasReachedMax;
}
