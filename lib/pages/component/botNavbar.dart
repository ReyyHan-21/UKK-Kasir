import 'package:flutter/material.dart';

class Botnavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const Botnavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_rounded),
          label: 'List Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt),
          label: 'Account',
        ),
      ],
    );
  }
}
