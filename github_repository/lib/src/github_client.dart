import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:github_repository/github_repository.dart';

class GithubClient {
  final String baseUrl;
  final http.Client httpClient;

  GithubClient({
    http.Client httpClient,
    this.baseUrl = "https://api.github.com/search/repositories?q=topic:flutter",
  }) : this.httpClient = httpClient ?? http.Client();

  Future<SearchResult> searchProjects(String term) async {
    final termQuery = term.isEmpty ? '' : '+$term+in:name,description';
    final response = await httpClient.get(Uri.parse("$baseUrl$termQuery"));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results);
    }
  }

  Future<SearchResult> searchProfiles(String profile) async {
    final profileQuery = profile.isEmpty ? '' : '+$profile+in:name';
    final response = await httpClient.get(Uri.parse("$baseUrl$profileQuery"));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
}
