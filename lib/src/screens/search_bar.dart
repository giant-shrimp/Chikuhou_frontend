import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget implements PreferredSizeWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  void _submission(text) {
    setState(() {
      _controller.clear();
      if (kDebugMode) {
        print(text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SizedBox(
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Container(
              width: 340,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search Text',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.clear),
                  contentPadding: EdgeInsets.only(left: 8.0),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (text) => _submission(text),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
