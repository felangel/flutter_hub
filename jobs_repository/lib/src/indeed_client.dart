import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:github_repository/jobs_repository.dart';

class IndeedClient {
  final String baseUrl;
  final http.Client httpClient;

  IndeedClient({
    http.Client httpClient,
    this.baseUrl = "https://www.indeed.com/q-Search-jobs.html",
  }) : this.httpClient = httpClient ?? http.Client();

  Future<SearchResult> search(String term) async {
    final termQuery = term.isEmpty ? '' : '+$term+in:name,description';
    final response = await httpClient.get(Uri.parse("$baseUrl$termQuery"));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
}
