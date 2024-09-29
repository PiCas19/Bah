import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/map_widget.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
              height:
                  50), // Spazio per distanziare dal bordo superiore dello schermo
          const Text(
            'Dove si va?',
            style: TextStyle(
              color: Colors.lightBlue,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
              height: 20), // Spazio tra il testo e il campo di ricerca
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Esempio: Palma di Maiorca',
                prefixIcon: const Icon(Icons.search),
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
              onSubmitted: (query) {
                setState(() {
                  _searchQuery = query; // Imposta la ricerca
                });
              },
            ),
          ),
          const SizedBox(
              height: 20), // Spazio tra la barra di ricerca e la mappa
          Expanded(
            child: MapWidget(
                searchQuery: _searchQuery), // Passa la ricerca alla mappa
          ),
        ],
      ),
    );
  }
}
