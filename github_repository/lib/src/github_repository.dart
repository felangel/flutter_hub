import 'dart:async';

import 'package:github_repository/github_repository.dart';

class GithubRepository {
  final GithubCache cache;
  final GithubClient client;

  GithubRepository(this.cache, this.client);

  Future<SearchResult> searchProjects(String term) async {
    final cacheKey = '__project__$term';
    if (cache.contains(cacheKey)) {
      return cache.get(cacheKey);
    } else {
      final result = await client.searchProjects(term);
      cache.set(cacheKey, result);
      return result;
    }
  }

  Future<SearchResult> searchProfiles(String term) async {
    final cacheKey = '__profile__$term';
    if (cache.contains(cacheKey)) {
      return cache.get(cacheKey);
    } else {
      final Map<String, bool> profiles = {};
      final result = await client.searchProfiles(term);
      final List<SearchResultItem> distinctItems = [];
      result.items.forEach((item) {
        if (profiles.containsKey(item.owner.login)) {
          return;
        }
        profiles[item.owner.login] = true;
        distinctItems.add(item);
      });
      final filteredResult = SearchResult(items: distinctItems);
      cache.set(cacheKey, filteredResult);
      return filteredResult;
    }
  }
}
