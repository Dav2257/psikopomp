import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static const _doc = 'psikopomp_v2';

  static Future<Map<String, dynamic>?> loadPetState() async {
    try {
      final snap = await _db.collection('pets').doc(_doc).get();
      return snap.exists ? snap.data() : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> savePetState({
    required double hunger,
    required int coins,
    int xp = 0,
    int level = 1,
    int soulsCollected = 0,
    int totalFed = 0,
    int quizCorrect = 0,
  }) async {
    try {
      await _db.collection('pets').doc(_doc).set({
        'hunger': hunger,
        'coins': coins,
        'xp': xp,
        'level': level,
        'soulsCollected': soulsCollected,
        'totalFed': totalFed,
        'quizCorrect': quizCorrect,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}
