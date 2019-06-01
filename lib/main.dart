import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:github_repository/github_repository.dart';
import 'package:flutter_hub/search/search.dart';

void main() {
  final GithubRepository _githubRepository = GithubRepository(
    GithubCache(),
    GithubClient(),
  );

  runApp(App(githubRepository: _githubRepository));
}

class App extends StatelessWidget {
  final GithubRepository githubRepository;

  const App({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hub',
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Hub')),
        body: SearchScreen(githubRepository: githubRepository),
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
        ),
      ),
    );
  }
}
