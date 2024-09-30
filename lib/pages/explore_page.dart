import 'package:flutter/material.dart';
import 'map_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String? _searchQuery;
  List<bool> _selectedButtons = [false, false, false];

  void _onButtonPressed(int index) {
    setState(() {
      for (int i = 0; i < _selectedButtons.length; i++) {
        _selectedButtons[i] = i == index;
      }
    });
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchQuery = query; // Aggiorna la query di ricerca
      });
      // Naviga alla pagina della mappa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(searchQuery: _searchQuery),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Dove si va?',
                  hintStyle: const TextStyle(fontSize: 20.0, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.lightBlue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                String buttonText;
                switch (index) {
                  case 0:
                    buttonText = 'Vicino a te';
                    break;
                  case 1:
                    buttonText = 'Popolari';
                    break;
                  case 2:
                    buttonText = 'Particolari';
                    break;
                  default:
                    buttonText = '';
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onButtonPressed(index),
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white, // Sfondo sempre bianco
                        border: Border.all(
                          color: _selectedButtons[index]
                              ? Colors.blue // Bordo blu quando selezionato
                              : Colors.grey, // Bordo grigio quando non selezionato
                        ),
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            color: _selectedButtons[index]
                                ? Colors.blue // Testo blu quando selezionato
                                : Colors.grey, // Testo grigio quando non selezionato
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Expanded(
            child: Center(child: Text('Fai una ricerca!')),
          ),
        ],
      ),
    );
  }
}
