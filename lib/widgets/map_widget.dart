import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../controllers/beach_controller.dart';
import '../models/beach_model.dart';

class MapWidget extends StatefulWidget {
  final String? searchQuery;

  const MapWidget({Key? key, this.searchQuery}) : super(key: key);

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
  List<Beach> _allBeaches = []; // Store all beaches
  final List<Beach> _markedBeaches = []; // Store currently marked beaches
  final ScrollController _scrollController =
  ScrollController(); // Add scroll controller

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadBeaches(); // Load all beaches on init
    _scrollController.addListener(_onScroll); // Listen to scroll changes
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose scroll controller
    super.dispose();
  }

  Future<void> _loadBeaches() async {
    _allBeaches = await _beachController.getBeaches();
    print(_allBeaches);
    _updateMarkers(_allBeaches); // Update markers with all beaches
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        _searchedPosition =
            LatLng(locations[0].latitude, locations[0].longitude);
        _mapController
            ?.animateCamera(CameraUpdate.newLatLng(_searchedPosition!));

        const double radiusInMeters = 10000;

        List<Beach> nearbyBeaches = _allBeaches.where((beach) {
          double distanceInMeters = Geolocator.distanceBetween(
            _searchedPosition!.latitude,
            _searchedPosition!.longitude,
            beach.coordinates.latitude,
            beach.coordinates.longitude,
          );
          return distanceInMeters <= radiusInMeters;
        }).toList();


        _updateMarkers(nearbyBeaches);
      }
    } catch (e) {
      print("Error searching for location: $e");
    }
  }

  void _updateMarkers(List<Beach> beaches) {
    _markers.clear();
    _markedBeaches.clear(); // Clear the previously marked beaches
    for (var beach in beaches) {
      _markers.add(
        Marker(
          markerId: MarkerId(beach.name),
          position:
          LatLng(beach.coordinates.latitude, beach.coordinates.longitude),
          infoWindow: InfoWindow(
            title: beach.name,
            snippet: '${beach.place} - Rating: ${beach.rating}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            setState(() {
              _selectedBeach = beach;
            });
            _showBeachDetails(beach); // Show beach details in modal
          },
        ),
      );
      _markedBeaches.add(beach); // Add to marked beaches
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
        LatLng(_selectedBeach!.coordinates.latitude,
            _selectedBeach!.coordinates.longitude),
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

  // Show the beach details in a modal bottom sheet
  void _showBeachDetails(Beach? beach) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              _buildMarkedBeachesCard(), // Show only marked beaches in the modal
            ],
          ),
        );
      },
    );
  }

  Widget _buildBeachCard(Beach beach, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBeach = beach; // Update selected beach
        });
        _moveToSelectedBeach(); // Move to selected beach on map
        Navigator.pop(context); // Close the modal
        _showBeachDetails(beach); // Show the selected beach details
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        color: isSelected
            ? Colors.blue[50]
            : Colors.white, // Highlight selected beach
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  beach.url, // Assuming your Beach model has imageUrl
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
                        color:
                        Colors.white, // Background color for the heart icon
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Stars on the right
                Row(
                  children: _buildRatingStars(beach.rating),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", // Assuming your Beach model has description
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
        controller: _scrollController, // Set the scroll controller
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

  void _onScroll() {
    // Calculate the current index based on scroll position
    double scrollPosition = _scrollController.position.pixels;
    double itemHeight = 100; // Adjust based on your item height
    int currentIndex = (scrollPosition / itemHeight).floor();

    if (currentIndex >= 0 && currentIndex < _markedBeaches.length) {
      setState(() {
        _selectedBeach = _markedBeaches[currentIndex]; // Update selected beach
      });
      _moveToSelectedBeach(); // Move to selected beach on map
    }
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != null &&
        widget.searchQuery != oldWidget.searchQuery) {
      _searchLocation(widget.searchQuery!);
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
          onCameraMove: (position) {
            setState(() {
              _showCurrentLocationIcon = true;
            });
          },
          zoomControlsEnabled: false,
          markers: _markers,
          onTap: (_) {
            setState(() {
              _selectedBeach = null; // Deselect beach when tapping on map
            });
          },
        ),
        if (_showCurrentLocationIcon)
          Positioned(
            bottom: 80,
            right: 10,
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
