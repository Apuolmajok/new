import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sharecare/models/user.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create AppUser object based on Firebase User
  AppUser? _userFromFirebaseUser(auth.User? user) {
    return user != null
        ? AppUser(
            userId: user.uid,
            name: '', // Name will be set during registration
            email: user.email ?? '',
            role: 'user', // Default role
            verificationStatus: 'Pending', // Default verification status
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
        : null;
  }

  // Auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Register with email and password
  Future<auth.User?> registerWithEmailPassword(String name, String email, String password, String role) async {
    try {
      auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      auth.User? user = userCredential.user;

      // Create a new document for the user with uid
      await _db.collection('users').doc(user?.uid).set({
        'name': name,
        'email': email,
        'role': role,
        'verificationStatus': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Send email verification
      await user?.sendEmailVerification();

      return user;
    } catch (e) {
      print("Error in registerWithEmailPassword: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<AppUser?> signInWithEmailPassword(String email, String password) async {
    try {
      auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      auth.User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Please verify your email.');
        return null; // Return null if email is not verified
      }
      return await _getUserDetails(user);
    } catch (e) {
      print("Error in signInWithEmailPassword: $e");
      return null;
    }
  }

  // Get user details from Firestore
  Future<AppUser?> _getUserDetails(auth.User? user) async {
    if (user == null) return null;

    try {
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print("Error in _getUserDetails: $e");
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error in signOut: $e");
    }
  }

  // Get user data
  Future<AppUser?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print("Error in getUserData: $e");
      return null;
    }
  }

  // Get vendor ID for a donee user
  Future<String?> getVendorId(String userId) async {
    try {
      final querySnapshot = await _db.collection('vendors')
          .where('owner', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } catch (e) {
      print("Error in getVendorId: $e");
      return null;
    }
  }

  // Register a new vendor
  Future<String?> registerVendor(String userId, String businessName, String businessAddress, String logoUrl) async {
    try {
      final vendorDoc = await _db.collection('vendors').add({
        'userId': userId,
        'businessName': businessName,
        'businessAddress': businessAddress,
        'logoUrl': logoUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return vendorDoc.id;
    } catch (e) {
      print("Error in registerVendor: $e");
      return null;
    }
  }

  // Upload vendor logo
  Future<String> uploadVendorLogo(String vendorId, File imageFile) async {
    try {
      final storageRef = _storage.ref().child('vendor_logos/$vendorId.png');
      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading logo: $e');
    }
  }

  // Update user data
  Future<void> updateUserData(AppUser user) async {
    try {
      await _db.collection('users').doc(user.userId).update(user.toMap());
    } catch (e) {
      print("Error in updateUserData: $e");
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      auth.User? currentUser = _auth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.delete();
      }
    } catch (e) {
      print("Error in deleteUser: $e");
    }
  }

  // Phone number verification
  Future<void> verifyPhoneNumber(String phoneNumber, Function(auth.PhoneAuthCredential) codeSentCallback) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (auth.PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSentCallback(auth.PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: '',
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Code auto retrieval timeout');
        },
      );
    } catch (e) {
      print("Error in verifyPhoneNumber: $e");
    }
  }

  // Sign in with phone number and SMS code
  Future<AppUser?> signInWithPhoneNumber(String verificationId, String smsCode) async {
    try {
      auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      auth.UserCredential userCredential = await _auth.signInWithCredential(credential);
      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print("Error in signInWithPhoneNumber: $e");
      return null;
    }
  }
}
