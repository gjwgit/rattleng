// pages.dart
import 'package:flutter/material.dart';

class Pages extends StatefulWidget {
  final List<Widget> children;

  const Pages({
    super.key,
    required this.children,
  });

  @override
  PagesState createState() => PagesState();
}

class PagesState extends State<Pages> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // By default, show the result page after build.
    // TODO yyx 20240627 not run after the second build.
    // _pageController = PageController(initialPage: widget.children.length - 1);
    _pageController = PageController(initialPage: 0);
    // debugPrint('in pageController');
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < widget.children.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToResultPage() {
    debugPrint('go to result page');
    // TODO yyx 20240624 might need change when we have more pages than 2.
    _goToNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_left,
            color: _currentPage > 0 ? Colors.black : Colors.grey,
            size: 32,
          ),
          onPressed: _currentPage > 0 ? _goToPreviousPage : null,
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: widget.children,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_right,
            size: 32,
            color: _currentPage < widget.children.length - 1
                ? Colors.black
                : Colors.grey,
          ),
          onPressed:
              _currentPage < widget.children.length - 1 ? _goToNextPage : null,
        ),
      ],
    );
  }
}
