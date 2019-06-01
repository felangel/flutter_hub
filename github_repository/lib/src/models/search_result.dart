import 'package:github_repository/github_repository.dart';

class SearchResult {
  final List<SearchResultItem> items;

  const SearchResult({this.items});

  static SearchResult fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map((dynamic item) =>
            SearchResultItem.fromJson(item as Map<String, dynamic>))
        .toList();
    return SearchResult(items: items);
  }
}
