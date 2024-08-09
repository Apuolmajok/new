// import 'package:cloud_firestore/cloud_firestore.dart';

// class UrgentNeedsService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Stream<List<Map<String, dynamic>>> getRecentUrgentNeeds() {
//     return _db.collection('urgentNeeds').snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
//     });
//   }

//   Future<void> addUrgentNeed(Map<String, dynamic> urgentNeed) async {
//     await _db.collection('urgentNeeds').add(urgentNeed);
//   }

//   Future<void> updateUrgentNeed(String id, Map<String, dynamic> urgentNeed) async {
//     await _db.collection('urgentNeeds').doc(id).update(urgentNeed);
//   }

//   Future<void> deleteUrgentNeed(String id) async {
//     await _db.collection('urgentNeeds').doc(id).delete();
//   }
// }




import 'package:cloud_firestore/cloud_firestore.dart';

class UrgentNeedsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getRecentUrgentNeeds() {
    return _db.collection('urgentNeeds').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'imageUrl': data['imageUrl'] ?? '',
          'title': data['title'] ?? '',
          'time': data['time'] ?? '',
          'rating': data['rating'] ?? 0,
          'coords': data['coords'] ?? {},
          'isAvailable': data['isAvailable'] ?? true,
          'vendorId': data['vendorId'] ?? '',
        };
      }).toList();
    });
  }

  Future<void> addUrgentNeed(Map<String, dynamic> urgentNeed) async {
    await _db.collection('urgentNeeds').add(urgentNeed);
  }

  Future<void> updateUrgentNeed(String id, Map<String, dynamic> urgentNeed) async {
    await _db.collection('urgentNeeds').doc(id).update(urgentNeed);
  }

  Future<void> deleteUrgentNeed(String id) async {
    await _db.collection('urgentNeeds').doc(id).delete();
  }
}
