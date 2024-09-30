import 'package:flutter/material.dart';
import '../widgets/map_widget.dart';

class MapPage extends StatefulWidget {
  final String? searchQuery; // Aggiungi la variabile searchQuery

  const MapPage({Key? key, this.searchQuery}) : super(key: key); // Passa la searchQuery al costruttore

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MapWidget(searchQuery: widget.searchQuery), // Usa widget.searchQuery
    );
  }
}
