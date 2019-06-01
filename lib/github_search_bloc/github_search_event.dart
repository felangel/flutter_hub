import 'package:equatable/equatable.dart';

abstract class GithubSearchEvent extends Equatable {
  GithubSearchEvent([List props = const []]) : super(props);
}

class FetchInitialProjects extends GithubSearchEvent {
  @override
  String toString() => 'FetchInitialProjects';
}

class FetchInitialProfiles extends GithubSearchEvent {
  @override
  String toString() => 'FetchInitialProfiles';
}

class ProjectTextChanged extends GithubSearchEvent {
  final String text;

  ProjectTextChanged({this.text}) : super([text]);

  @override
  String toString() => 'ProjectTextChanged { text: $text }';
}

class ProfileTextChanged extends GithubSearchEvent {
  final String text;

  ProfileTextChanged({this.text}) : super([text]);

  @override
  String toString() => 'ProfileTextChanged { text: $text }';
}
