import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.lightBlue, // Sfondo blu chiaro
      selectedItemColor: Colors.yellow, // Colore dell'icona selezionata
      unselectedItemColor: Colors.white54, // Colore dell'icona non selezionata
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Esplora',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Preferiti',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_drive_file),
          label: 'Itinerario',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messaggi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profilo',
        ),
      ],
    );
  }
}
