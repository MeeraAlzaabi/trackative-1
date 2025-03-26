import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as d;

import 'package:trackactive/models/user.dart';

class FirebaseFunc {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Checking User
  bool isLogged() => auth.currentUser?.uid != null ? true : false;

  // Login User
  Future<String> loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        return "";
      } else {
        return ".";
      }
    } on FirebaseException catch (e) {
      d.log(e.toString());
      if (e.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        return "Email is badly formatted";
      } else if (e.toString() ==
          "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
        return "Email or password is wrong";
      } else if (e.toString() ==
          "[firebase_auth/weak-password] Password should be at least 6 characters") {
        return "Password should be at least 6 characters";
      } else if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        return "The email address is already in use by another account";
      } else {
        return "";
      }
    }
  }

  // Signup User
  Future<String> createUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        var uid = auth.currentUser!.uid;
        if (uid.isNotEmpty) {
          await firestore.collection("users").doc(uid).get().then((v) async {
            if (!v.exists) {
              var user = UserModel(
                email: email,
                password: password,
                id: uid,
              );
              await firestore.collection("users").doc(uid).set(user.toMap());
            }
          });
        } else {
          throw Exception("UID error");
        }
        return "";
      }
      return "..";
    } on FirebaseException catch (e) {
      if (e.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        return "Email is badly formatted";
      } else if (e.toString() ==
          "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
        return "Email or password is wrong";
      } else if (e.toString() ==
          "[firebase_auth/weak-password] Password should be at least 6 characters") {
        return "Password should be at least 6 characters";
      } else if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        return "The email address is already in use by another account";
      } else {
        return "";
      }
    }
  }

  // Logout User
  Future<bool> logout() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      d.log(e.toString());
      return false;
    }
  }

  // Forgot Passowrd
  Future<String> forgotPassword(String email) async {
    try {
      if (email.isNotEmpty) {
        await auth.sendPasswordResetEmail(email: email);
        return "";
      } else {
        return ".";
      }
    } catch (e) {
      if (e.toString() ==
          "[firebase_auth/invalid-email] The email address is badly formatted.") {
        return "Email is badly formatted";
      } else if (e.toString() ==
          "[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.") {
        return "Email or password is wrong";
      } else if (e.toString() ==
          "[firebase_auth/weak-password] Password should be at least 6 characters") {
        return "Password should be at least 6 characters";
      } else if (e.toString() ==
          "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
        return "The email address is already in use by another account";
      } else {
        return "";
      }
    }
  }
}
