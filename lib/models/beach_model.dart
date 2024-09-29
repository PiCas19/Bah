import 'package:cloud_firestore/cloud_firestore.dart';

class Beach {
  final String name;
  final String place;
  final GeoPoint coordinates;
  final String type;
  final double rating;
  final String url;

  Beach(
      {required this.name,
      required this.place,
      required this.coordinates,
      required this.type,
      required this.rating,
      required this.url});
}
