import '../pages/profile_page.dart';
import '../pages/explore_page.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ExplorePage(),
    Text("Preferiti"),
    Text("Itinerario"),
    Text("Messaggi"),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
        bottomNavigationBar:BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white, // Set background color to white
          selectedItemColor: Colors.blue, // Color for selected item
          unselectedItemColor: Colors.grey, // Color for unselected items
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.search, 0),
              label: 'Esplora',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.favorite_outline, 1), // Outline icon for favorite
              label: 'Preferiti',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.directions_boat, 2), // Boat icon for 'Itinerario'
              label: 'Itinerario',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.message_outlined, 3), // Outline message icon
              label: 'Messaggi',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person_outline, 4), // Outline profile icon
              label: 'Profilo',
            ),
          ],
        )
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _selectedIndex == index ? Colors.blue.shade100 : Colors.transparent, // Blue background for selected
      ),
      padding: EdgeInsets.all(8), // Spacing around the icon
      child: Icon(icon, size: 24), // Icon size
    );
  }
}
