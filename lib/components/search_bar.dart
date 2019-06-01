import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onClear;
  final String hintText;

  SearchBar({
    Key key,
    this.onChanged,
    this.onClear,
    this.hintText,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        widget.onChanged(text);
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          child: Icon(Icons.clear),
          onTap: _onClearTapped,
        ),
        border: InputBorder.none,
        hintText: widget.hintText,
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    widget.onClear();
  }
}
