import 'package:flutter/material.dart';
import 'package:topick/constants/ColorConstants.dart';
import 'package:topick/pages/TopPage.dart';

import '../codes/ButtomTabCode.dart';
import 'BrowsePage.dart';
import 'MyListPage.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);
  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;
  final _pageWidgets = [
    const TopPage(),
    const MyListPage(),
    const BrowsePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/header-parts/header.png', height: 50),
        backgroundColor: ColorConstants.baseColor,
      ),
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorConstants.baseColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: const Icon(Icons.search), label: BottomTab.search.getLabel()),
          BottomNavigationBarItem(icon: const Icon(Icons.assignment), label: BottomTab.myList.getLabel()),
          BottomNavigationBarItem(icon: const Icon(Icons.groups), label: BottomTab.browse.getLabel()),
        ],
        currentIndex: _currentIndex,
        fixedColor: ColorConstants.subColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index );
}
