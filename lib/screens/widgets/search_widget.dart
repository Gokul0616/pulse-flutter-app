import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  // FocusNode to handle text field focus events
  final FocusNode focusNode = FocusNode();
  bool isFocusedSearchBar = false; // To manage search bar state

  @override
  void initState() {
    super.initState();

    // Listen to focus changes
    focusNode.addListener(() {
      setState(() {
        isFocusedSearchBar = focusNode.hasFocus; // Update focus state
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose(); // Clean up the focus node when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: GestureDetector(
              onTap: () {
                // Close the keyboard or take some other action
                focusNode.unfocus(); // Unfocus to dismiss the keyboard
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Focus(
                  focusNode: focusNode,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: isFocusedSearchBar
                          ? "Search"
                          : 'Search with username or title',
                      hintStyle:
                          TextStyle(color: Colors.black.withOpacity(0.6)),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    onTap: () {
                      print('Search field clicked');
                    },
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isFocusedSearchBar = false;
          });
          focusNode.unfocus(); // Unfocus the text field if tapping outside
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1,
            ),
            itemCount: 30,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
