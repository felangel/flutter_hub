import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:github_repository/github_repository.dart';
import 'package:flutter_hub/project_search/bloc/bloc.dart';

class ProjectSearch extends StatefulWidget {
  final GithubRepository githubRepository;

  const ProjectSearch({
    Key key,
    @required this.githubRepository,
  }) : super(key: key);

  @override
  _ProjectSearchState createState() => _ProjectSearchState();
}

class _ProjectSearchState extends State<ProjectSearch>
    with AutomaticKeepAliveClientMixin {
  SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(
      githubRepository: widget.githubRepository,
    );
    _searchBloc.dispatch(FetchInitial());
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        _SearchBar(searchBloc: _searchBloc),
        _SearchBody(searchBloc: _searchBloc)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SearchBar extends StatefulWidget {
  final SearchBloc searchBloc;

  _SearchBar({Key key, this.searchBloc}) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _textController = TextEditingController();

  SearchBloc get searchBloc => widget.searchBloc;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        searchBloc.dispatch(
          TextChanged(text: text),
        );
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: 'Search for Flutter Projects',
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    searchBloc.dispatch(TextChanged(text: ''));
  }
}

class _SearchBody extends StatelessWidget {
  final SearchBloc searchBloc;

  const _SearchBody({Key key, this.searchBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchEvent, SearchState>(
      bloc: searchBloc,
      builder: (BuildContext context, SearchState state) {
        if (state is SearchStateLoading) {
          return CircularProgressIndicator();
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? Text('No Results. Please try again.')
              : Expanded(child: _SearchResults(items: state.items));
        }
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<SearchResultItem> items;

  const _SearchResults({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return _SearchResultItem(item: items[index]);
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final SearchResultItem item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(item.owner.avatarUrl),
      ),
      title: Text(item.fullName),
      onTap: () async {
        if (await canLaunch(item.htmlUrl)) {
          await launch(item.htmlUrl);
        }
      },
    );
  }
}
