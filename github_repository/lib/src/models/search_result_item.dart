import 'package:github_repository/github_repository.dart';

class SearchResultItem {
  final String fullName;
  final String name;
  final String htmlUrl;
  final GithubUser owner;

  const SearchResultItem({this.fullName, this.name, this.htmlUrl, this.owner});

  static SearchResultItem fromJson(dynamic json) {
    return SearchResultItem(
      fullName: json['full_name'] as String,
      name: json['name'] as String,
      htmlUrl: json['html_url'] as String,
      owner: GithubUser.fromJson(json['owner']),
    );
  }
}
