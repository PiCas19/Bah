import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../controllers/beach_controller.dart';
import '../models/beach_model.dart';
import 'dart:async';

class MapWidget extends StatefulWidget {
  final String? searchQuery;
  final Function(String)? onSearchQueryChanged;

  const MapWidget({Key? key, this.searchQuery, this.onSearchQueryChanged}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng? _searchedPosition;
  LatLng? _currentPosition;
  bool _showCurrentLocationIcon = true;
  Beach? _selectedBeach;
  final BeachController _beachController = BeachController();
  final Set<String> _favoriteBeaches = {};
  List<Beach> _allBeaches = [];
  final List<Beach> _markedBeaches = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadBeaches();
    _scrollController.addListener(_onScroll);
    _initializeSearchQuery();

    _searchController.addListener(_onSearchChanged);
  }

  void _initializeSearchQuery() {
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
      _searchLocation(widget.searchQuery!);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _searchLocation(_searchController.text);
        widget.onSearchQueryChanged?.call(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadBeaches() async {
    _allBeaches = await _beachController.getBeaches();
    _updateMarkers(_allBeaches);
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        //_moveToCurrentPosition(); // Move to current position when location is found
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unable to get location: $e")));
    }
  }

  void _animateCamera(LatLng target) {
    _mapController?.animateCamera(CameraUpdate.newLatLng(target));
  }

  Future<void> _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        // Adding a small delay before proceeding
        await Future.delayed(const Duration(seconds: 1));

        _searchedPosition = LatLng(locations[0].latitude, locations[0].longitude);
        _animateCamera(_searchedPosition!);
        _filterNearbyBeaches(_searchedPosition!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error searching location: $e")),
      );
    }
  }


  void _filterNearbyBeaches(LatLng position) {
    const double radiusInMeters = 10000;
    List<Beach> nearbyBeaches = _allBeaches.where((beach) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        beach.coordinates.latitude,
        beach.coordinates.longitude,
      );
      return distance <= radiusInMeters;
    }).toList();

    _updateMarkers(nearbyBeaches);
  }

  void _updateMarkers(List<Beach> beaches) {
    _markers.clear();
    _markedBeaches.clear();
    for (var beach in beaches) {
      _markers.add(
        Marker(
          markerId: MarkerId(beach.name),
          position: LatLng(beach.coordinates.latitude, beach.coordinates.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            setState(() {
              _selectedBeach = beach;
            });
            _showBeachDetails(beach);
          },
        ),
      );
      _markedBeaches.add(beach);
    }
    setState(() {});
  }

  Future<void> _moveToCurrentPosition() async {
    if (_currentPosition != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
      setState(() {
        _showCurrentLocationIcon = false;
      });
    }
  }

  Future<void> _moveToSelectedBeach() async {
    if (_selectedBeach != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(
        LatLng(_selectedBeach!.coordinates.latitude, _selectedBeach!.coordinates.longitude),
      ));
    }
  }

  void _toggleFavorite(String beachName) {
    setState(() {
      if (_favoriteBeaches.contains(beachName)) {
        _favoriteBeaches.remove(beachName);
      } else {
        _favoriteBeaches.add(beachName);
      }
    });
  }

  void _showBeachDetails(Beach? beach) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: _buildMarkedBeachesCard(),
        );
      },
    );
  }

  Widget _buildBeachCard(Beach beach, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBeach = beach;
        });
        _moveToSelectedBeach();
        Navigator.pop(context);
        _showBeachDetails(beach);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: isSelected ? Colors.blue[50] : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  beach.url,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(beach.name),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _favoriteBeaches.contains(beach.name)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  beach.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: _buildRatingStars(beach.rating),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkedBeachesCard() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _markedBeaches.length,
        itemBuilder: (context, index) {
          Beach beach = _markedBeaches[index];
          return _buildBeachCard(beach, isSelected: _selectedBeach == beach);
        },
      ),
    );
  }

  List<Widget> _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;

    List<Widget> stars = [];

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star, color: Colors.blue));
      } else if (i == fullStars && hasHalfStar) {
        stars.add(const Icon(Icons.star_half, color: Colors.blue));
      } else {
        stars.add(const Icon(Icons.star_border, color: Colors.blue));
      }
    }

    return stars;
  }

  // TODO rileggere funzione di spostamento marker
  void _onScroll() {
    double scrollPosition = _scrollController.position.pixels;
    double itemHeight = 100;
    int currentIndex = (scrollPosition / itemHeight).floor();

    if (currentIndex >= 0 && currentIndex < _markedBeaches.length) {
      setState(() {
        _selectedBeach = _markedBeaches[currentIndex];
      });
      _moveToSelectedBeach();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _searchedPosition == null
            ? const Center(child: CircularProgressIndicator())
            : GoogleMap(
          mapToolbarEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _searchedPosition!,
            zoom: 13,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          zoomControlsEnabled: false,
          markers: _markers,
        ),
        Positioned(
          top: 50,
          left: 10,
          right: 10,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              hintStyle: const TextStyle(fontSize: 20.0, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.lightBlue),
              fillColor: Colors.white,
              hintText: 'Cerca una spiaggia...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 20.0,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            onPressed: _moveToCurrentPosition,
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
