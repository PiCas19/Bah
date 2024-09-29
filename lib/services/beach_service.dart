import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/beach_model.dart';

class BeachService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Beach>> fetchBeaches() async {
    final QuerySnapshot snapshot = await _firestore.collection("beaches").get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print(data['name']);
      return Beach(
          name: data['name'],
          place: data['place'],
          coordinates: data['coordinates'],
          type: data['type'],
          rating: data['rating'],
          url: data['url']);
    }).toList();
  }
}
