import 'package:cloud_firestore/cloud_firestore.dart';

class VendorService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch posts for a specific vendor
  Stream<List<Map<String, dynamic>>> getVendorPosts(String vendorId) {
    return _db
        .collection('vendorPosts')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Add a new post
  Future<void> addPost(Map<String, dynamic> post) async {
    await _db.collection('vendorPosts').add(post);
  }

  // Update an existing post
  Future<void> updatePost(String postId, Map<String, dynamic> post) async {
    await _db.collection('vendorPosts').doc(postId).update(post);
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await _db.collection('vendorPosts').doc(postId).delete();
  }

  // Fetch donations for a specific vendor
  Stream<List<Map<String, dynamic>>> getVendorDonations(String vendorId) {
    return _db
        .collection('donations')
        .where('vendorId', isEqualTo: vendorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }
}
