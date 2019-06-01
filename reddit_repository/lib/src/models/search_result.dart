import 'package:reddit_repository/reddit_repository.dart';

class SearchResult {
  final List<Article> items;

  const SearchResult({this.items});

  static SearchResult fromJson(Map<String, dynamic> json) {
    final items = (json['data']['children'] as List<dynamic>)
        .map((dynamic item) => Article.fromJson(item as Map<String, dynamic>))
        .toList();
    return SearchResult(items: items);
  }
}
