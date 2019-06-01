import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String title;
  final String url;
  final String thumbnail;
  final String author;

  Article({
    this.title,
    this.url,
    this.author,
    this.thumbnail,
  }) : super([title, url, author, thumbnail]);

  static Article fromJson(dynamic json) {
    return Article(
      title: json['data']['title'] as String,
      url: 'https://www.reddit.com${json['data']['permalink']}',
      author: json['data']['author'] as String,
      thumbnail: json['data']['thumbnail'] as String,
    );
  }

  @override
  String toString() =>
      'Article { title: $title, url: $url, author: $author, thumbnail: $thumbnail }';
}
