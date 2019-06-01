import 'dart:async';

import 'package:jobs_repository/jobs_repository.dart';

class JobsRepository {
  final IndeedCache cache;
  final IndeedClient client;

  JobsRepository(this.cache, this.client);

  Future<SearchResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await client.search(term);
      cache.set(term, result);
      return result;
    }
  }
}
