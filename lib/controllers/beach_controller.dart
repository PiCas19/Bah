import '../models/beach_model.dart';
import '../services/beach_service.dart';

class BeachController {
  final BeachService _beachService = BeachService();

  Future<List<Beach>> getBeaches() async {
    try {
      return await _beachService.fetchBeaches();
    } catch (e) {
      return []; // Restituisci una lista vuota in caso di errore
    }
  }
}
