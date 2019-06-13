import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reddit_repository/reddit_repository.dart';
import 'package:flutter_hub/reddit_search_bloc/bloc.dart';

class NewsSearch extends StatefulWidget {
  @override
  _NewsSearchState createState() => _NewsSearchState();
}

class _NewsSearchState extends State<NewsSearch>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  RedditSearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchBloc = BlocProvider.of<RedditSearchBloc>(context);
    _searchBloc.dispatch(FetchArticles());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<RedditSearchEvent, RedditSearchState>(
      bloc: BlocProvider.of<RedditSearchBloc>(context),
      builder: (BuildContext context, RedditSearchState state) {
        if (state is SearchStateLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is SearchStateError) {
          return Center(child: Text(state.error));
        }
        if (state is SearchStateSuccess) {
          return state.items.isEmpty
              ? Center(child: Text('No Results'))
              : _SearchResults(
                  items: state.items,
                  scrollController: _scrollController,
                );
        }
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      print('dispatching Fetch');
      _searchBloc.dispatch(FetchArticles());
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class _SearchResults extends StatelessWidget {
  final List<Article> items;
  final ScrollController scrollController;

  const _SearchResults({
    Key key,
    this.items,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<RedditSearchBloc>(context).currentState
        as SearchStateSuccess;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return index >= state.items.length
            ? BottomLoader()
            : _SearchResultItem(item: items[index]);
      },
      itemCount:
          state.hasReachedMax ? state.items.length : state.items.length + 1,
      controller: scrollController,
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final Article item;

  const _SearchResultItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('item $item');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: _thumbnail(item.thumbnail),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
      subtitle: Text(item.author),
      dense: true,
      onTap: () async {
        if (await canLaunch(item.url)) {
          await launch(item.url);
        }
      },
    );
  }

  Widget _thumbnail(String url) {
    if (url.contains('http')) {
      return Image.network(url);
    }
    return Image.network(
        'https://logodix.com/logo/576948.png');
  }
}
