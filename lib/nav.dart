import 'package:flutter/material.dart';
import 'package:klosterguide/discover.dart';
import 'package:klosterguide/guideactivity.dart';
import 'package:klosterguide/main.dart';
import 'package:klosterguide/map.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    guideactivity(),
    Discoverpage(),
    Karte(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.amp_stories,
            ),
            title: Text(
              'Entdecken',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_location_alt_rounded,
            ),
            title: Text(
              'Map',
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
