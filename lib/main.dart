import 'package:flutter/material.dart';
import 'package:flutter_hub/reddit_search_bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hub/simple_bloc_delegate.dart';
import 'package:github_repository/github_repository.dart';
import 'package:reddit_repository/reddit_repository.dart';
import 'package:flutter_hub/project_search/project_search.dart';
import 'package:flutter_hub/profile_search/profile_search.dart';
import 'package:flutter_hub/news_search/news_search.dart';
import 'package:flutter_hub/github_search_bloc/bloc.dart';

void main() {
  final GithubRepository _githubRepository = GithubRepository(
    GithubCache(),
    GithubClient(),
  );
  final RedditRepository _redditRepository = RedditRepository(
    RedditClient(),
  );
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App(
    githubRepository: _githubRepository,
    redditRepository: _redditRepository,
  ));
}

enum AppTab { project, profile, news }

class App extends StatefulWidget {
  final GithubRepository githubRepository;
  final RedditRepository redditRepository;

  const App({
    Key key,
    @required this.githubRepository,
    @required this.redditRepository,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  GithubRepository get githubRepository => widget.githubRepository;
  RedditRepository get redditRepository => widget.redditRepository;
  GithubSearchBloc _projectSearchBloc;
  GithubSearchBloc _profileSearchBloc;
  RedditSearchBloc _newsSearchBloc;

  AppTab _currentTabIndex = AppTab.project;

  @override
  void initState() {
    super.initState();
    _projectSearchBloc = GithubSearchBloc(githubRepository: githubRepository);
    _profileSearchBloc = GithubSearchBloc(githubRepository: githubRepository);
    _newsSearchBloc = RedditSearchBloc(redditRepository: redditRepository);
  }

  @override
  void dispose() {
    _projectSearchBloc.dispose();
    _profileSearchBloc.dispose();
    _newsSearchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0XFF0b71bf),
      ),
      title: 'FlutterHub',
      home: Scaffold(
        appBar: AppBar(
          title: Text('FlutterHub'),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 8.0),
            child: Image.asset('assets/flutter_logo.png'),
          ),
        ),
        body: _activeTab(_currentTabIndex),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(
              iconData: Icons.code,
              title: 'Projects',
            ),
            TabData(
              iconData: Icons.person,
              title: 'Profiles',
            ),
            TabData(
              iconData: Icons.new_releases,
              title: 'News',
            ),
          ],
          onTabChangedListener: (index) {
            setState(() {
              _currentTabIndex = AppTab.values[index];
            });
          },
        ),
      ),
    );
  }

  Widget _activeTab(AppTab tab) {
    switch (tab) {
      case AppTab.project:
        return BlocProvider<GithubSearchBloc>(
          bloc: _projectSearchBloc,
          child: ProjectSearch(),
        );
      case AppTab.profile:
        return BlocProvider<GithubSearchBloc>(
          bloc: _profileSearchBloc,
          child: ProfileSearch(),
        );
      case AppTab.news:
        return BlocProvider<RedditSearchBloc>(
          bloc: _newsSearchBloc,
          child: NewsSearch(),
        );
      default:
        return BlocProvider<GithubSearchBloc>(
          bloc: _projectSearchBloc,
          child: ProjectSearch(),
        );
    }
  }
}
