import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:jobs_repository/jobs_repository.dart';
import 'package:github_repository/github_repository.dart';
import 'package:flutter_hub/project_search/project_search.dart';
import 'package:flutter_hub/profile_search/profile_search.dart';
import 'package:flutter_hub/job_search/job_search.dart';

void main() {
  final GithubRepository _githubRepository = GithubRepository(
    GithubCache(),
    GithubClient(),
  );

  runApp(App(githubRepository: _githubRepository));
}

enum AppTab { project, profile, job }

class App extends StatefulWidget {
  final GithubRepository githubRepository;
  final JobsRepository jobsRepository;

  const App({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  GithubRepository get githubRepository => widget.githubRepository;
  AppTab _currentTabIndex = AppTab.project;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterHub',
      home: Scaffold(
        appBar: AppBar(title: Text('FlutterHub')),
        body: _activeTab(_currentTabIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.code),
              title: Text('Projects'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profiles'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              title: Text('Jobs'),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentTabIndex = AppTab.values[index];
            });
          },
          currentIndex: _currentTabIndex.index,
        ),
      ),
    );
  }

  Widget _activeTab(AppTab tab) {
    switch (tab) {
      case AppTab.project:
        return ProjectSearch(githubRepository: githubRepository);
      case AppTab.profile:
        return ProfileSearch();
      case AppTab.job:
        return JobSearch();
      default:
        return ProjectSearch(githubRepository: githubRepository);
    }
  }
}
