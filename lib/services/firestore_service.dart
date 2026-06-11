import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  static final FirebaseFirestore? _db = _initDb();

  static FirebaseFirestore? _initDb() {
    try {
      // Cek apakah Firebase sudah diinisialisasi
      if (Firebase.apps.isEmpty) return null;
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  static const String _collection = 'pets';
  static const String _docId = 'default';

  static DocumentReference<Map<String, dynamic>>? get _doc {
    final db = _db;
    if (db == null) return null;
    return db.collection(_collection).doc(_docId);
  }

  /// Simpan state pet ke Firestore
  static Future<void> savePetState({
    required double hunger,
    required int coins,
  }) async {
    final doc = _doc;
    if (doc == null) return; // Firebase belum siap
    try {
      await doc.set(
        {
          'hunger': hunger,
          'coins': coins,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      // ignore: avoid_print
      print('[FirestoreService] savePetState error: $e');
    }
  }

  /// Muat state pet dari Firestore.
  /// Mengembalikan map {'hunger': double, 'coins': int} atau null kalau belum ada data.
  static Future<Map<String, dynamic>?> loadPetState() async {
    final doc = _doc;
    if (doc == null) return null; // Firebase belum siap
    try {
      final snap = await doc.get();
      if (!snap.exists || snap.data() == null) return null;
      final data = snap.data()!;
      return {
        'hunger': (data['hunger'] as num?)?.toDouble() ?? 75.0,
        'coins': (data['coins'] as num?)?.toInt() ?? 40,
      };
    } catch (e) {
      // ignore: avoid_print
      print('[FirestoreService] loadPetState error: $e');
      return null;
    }
  }
}
