import 'dart:async';

import 'package:reddit_repository/reddit_repository.dart';

class RedditRepository {
  final RedditClient client;

  RedditRepository(this.client);

  Future<SearchResult> getArticles(int count) async {
    final result = await client.getArticles(count);
    return result;
  }
}
