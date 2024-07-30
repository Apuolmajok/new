import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharecare/models/category.dart';
import 'package:sharecare/models/donation.dart';
import 'package:sharecare/models/donee.dart';
import 'package:sharecare/models/impact.dart';
import 'package:sharecare/models/product.dart';
import 'package:sharecare/models/user.dart';
import 'package:sharecare/models/volunteer.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Vendor CRUD Operations
  Future<void> addVendor(Vendor vendor) {
    return _db.collection('vendors').add(vendor.toMap());
  }

  Stream<List<Vendor>> getVendors() {
    return _db.collection('vendors').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Vendor.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateVendor(Vendor vendor) {
    return _db.collection('vendors').doc(vendor.vendorId).update(vendor.toMap());
  }

  Future<void> deleteVendor(String vendorId) {
    return _db.collection('vendors').doc(vendorId).delete();
  }






  // User CRUD Operations
  Future<void> addUser(AppUser user) {
    return _db.collection('users').add(user.toMap());
  }

  Stream<List<AppUser>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AppUser.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateUser(AppUser user) {
    return _db.collection('users').doc(user.userId).update(user.toMap());
  }

  Future<void> deleteUser(String userId) {
    return _db.collection('users').doc(userId).delete();
  }





  // Donation CRUD Operations
  Future<void> addDonation(Donation donation) {
    return _db.collection('donations').add(donation.toMap());
  }

  Stream<List<Donation>> getDonations() {
    return _db.collection('donations').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Donation.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateDonation(Donation donation) {
    return _db.collection('donations').doc(donation.donationId).update(donation.toMap());
  }

  Future<void> deleteDonation(String donationId) {
    return _db.collection('donations').doc(donationId).delete();
  }




  // Product CRUD Operations
  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toMap());
  }

  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateProduct(Product product) {
    return _db.collection('products').doc(product.productId).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }






  // Volunteer CRUD Operations
  Future<void> addVolunteer(Volunteer volunteer) {
    return _db.collection('volunteers').add(volunteer.toMap());
  }

  Stream<List<Volunteer>> getVolunteers() {
    return _db.collection('volunteers').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Volunteer.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateVolunteer(Volunteer volunteer) {
    return _db.collection('volunteers').doc(volunteer.volunteerId).update(volunteer.toMap());
  }

  Future<void> deleteVolunteer(String volunteerId) {
    return _db.collection('volunteers').doc(volunteerId).delete();
  }






  // Category CRUD Operations
  Future<void> addCategory(Category category) {
    return _db.collection('categories').add(category.toMap());
  }

  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateCategory(Category category) {
    return _db.collection('categories').doc(category.categoryId).update(category.toMap());
  }

  Future<void> deleteCategory(String categoryId) {
    return _db.collection('categories').doc(categoryId).delete();
  }






  // Impact CRUD Operations
  Future<void> addImpact(Impact impact) {
    return _db.collection('impacts').add(impact.toMap());
  }

  Stream<List<Impact>> getImpacts() {
    return _db.collection('impacts').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Impact.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateImpact(Impact impact) {
    return _db.collection('impacts').doc(impact.impactId).update(impact.toMap());
  }

  Future<void> deleteImpact(String impactId) {
    return _db.collection('impacts').doc(impactId).delete();
  }
}
