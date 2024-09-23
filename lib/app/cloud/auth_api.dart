import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishing_helper/app/models/journey/auth/auth_response.dart';

import '../models/journey/auth/user_model.dart';

class AuthApi {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AuthResponse> login(String email, String password) async {
    return await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      return AuthResponse(
          '200', '', value.user?.uid ?? '', '', value.user?.email ?? '');
    }).catchError((error) async {
      return AuthResponse(error.code, error.message, '', '', '');
    });
  }

  Future<AuthResponse> register(String email, String password) async {
    return await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      addUserToFirestore(value.user?.uid ?? '', value.user?.email ?? '');
      return AuthResponse(
          '200', '', value.user?.uid ?? '', '', value.user?.email ?? '');
    }).catchError((error) async {
      return AuthResponse(error.code, error.message, '', '', '');
    });
  }

  Future<void> addUserToFirestore(String uid, String email) async {
    _firestore.collection('users').doc(uid).set({'uid': uid, 'email': email});
  }

  Future<List<UserModel>> getAllUsers() async => await _firestore
      .collection('users')
      .get()
      .then((value) => List.from(value.docs.map((e) => UserModel.fromJson(e.data()))));
}
