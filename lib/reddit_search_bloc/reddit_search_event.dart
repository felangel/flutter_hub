import 'package:equatable/equatable.dart';

abstract class RedditSearchEvent extends Equatable {
  RedditSearchEvent([List props = const []]) : super(props);
}

class FetchArticles extends RedditSearchEvent {
  @override
  String toString() => 'FetchArticles';
}
