class IndeedUser {
  final String login;
  final String avatarUrl;

  const IndeedUser({this.login, this.avatarUrl});

  static IndeedUser fromJson(dynamic json) {
    return IndeedUser(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }
}
