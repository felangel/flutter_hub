import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reddit_repository/reddit_repository.dart';
import 'package:catcher/catcher_plugin.dart';

class RedditClient {
  final String baseUrl;
  final http.Client httpClient;

  RedditClient({
    http.Client httpClient,
    this.baseUrl = "https://www.reddit.com/r/flutterdev/hot/.json",
  }) : this.httpClient = httpClient ?? http.Client();

  Future<SearchResult> getArticles(int count) async {
    print('GET $baseUrl?count=$count');
    final response = await httpClient.get(Uri.parse("$baseUrl?count=$count"));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError();
    }
  }
}
