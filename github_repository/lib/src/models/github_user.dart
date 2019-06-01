class GithubUser {
  final String login;
  final String avatarUrl;
  final String url;
  final String htmlUrl;

  const GithubUser({this.login, this.avatarUrl, this.url, this.htmlUrl});

  static GithubUser fromJson(dynamic json) {
    return GithubUser(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
      url: json['url'] as String,
      htmlUrl: json['html_url'] as String,
    );
  }
}
