import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<bool> addUser({
    required String fullName,
    required String email,
  }) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await users.doc(email).set({
        'full_name': fullName,
        'email': email,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<String?> getUser(String email) async {
    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['full_name'];
    } catch (e) {
      return 'Error fetching user';
    }
  }
}