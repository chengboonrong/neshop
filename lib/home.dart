import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neshop/collection.dart';
import 'package:neshop/deals.dart';
import 'package:neshop/new.dart';
import 'package:neshop/search.dart';
import 'package:neshop/settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<double> converters = List<double>();
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          NewPage(),
          DealsPage(),
          CollectionPage(),
          CollectionPage(),
          SettingsPage()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        splashColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        child: Icon(Icons.search_outlined),
        elevation: 4.0,
      ),
      bottomNavigationBar: CupertinoTabBar(
        iconSize: 25,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() {
          print('Index: $index');
          print('Count: $count');

          if (_currentIndex == index) {
            setState(() {
              count += 1;
            });
          } else {
            setState(() {
              count = 0;
            });
          }

          if (index != 2) {
            _currentIndex = index;
          }

          if (count == 2 && index == 0) {
            // CupertinoPageRoute(builder: null)
            Navigator.of(context).push(CupertinoPageRoute<void>(
              title: "Click me",
              builder: (BuildContext context) => HomePage(),
            ));
          } else if (count == 2 && index == 1) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.new_releases_outlined), label: 'New'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined), label: 'Deal'),
          BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: Icon(Icons.local_offer_rounded),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined), label: 'Collection'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
