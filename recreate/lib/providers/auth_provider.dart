import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recreate/allConstants/all_constants.dart';
import 'package:recreate/models/chat_user.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider(
      {required this.googleSignIn,
      required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.prefs});

  String? getFirebaseUserId() {
    return prefs.getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.({String? accessToken, String? idToken}) async {}(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      User? firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> document = result.docs;
        if (document.isEmpty) {
          firebaseFirestore
              .collection(FirestoreConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            FirestoreConstants.displayName: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null
          });

          User? currentUser = firebaseUser;
          prefs.getString(FirestoreConstants.id, currentUser.uid);
           prefs.getString(
              FirestoreConstants.displayName, currentUser.displayName ?? "");
           prefs.getString(
              FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await prefs.getString(
              FirestoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
          await prefs.getString(FirestoreConstants.id, userChat.id);
          await prefs.getString(
              FirestoreConstants.displayName, userChat.displayName);
          await prefs.getString(FirestoreConstants.aboutMe, userChat.aboutMe);
          await prefs.getString(
              FirestoreConstants.phoneNumber, userChat.phoneNumber);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> googleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}

class User {
  get uid => null;
  
  get displayName => null;
  
  get photoURL => null;
  
  get phoneNumber => null;
}

class GoogleAuthProvider {
}

class AuthCredential {
}

class SharedPreferences {
  String? getString(String id, uid) {}

  static getInstance() {}
}

class FirebaseAuth {
  static var instance;

  signInWithCredential(AuthCredential credential) {}
  
  signOut() {}
}

class GoogleSignIn {
  isSignedIn() {}
  
  signIn() {}
  
  signOut() {}
  
  disconnect() {}
}

class GoogleSignInAccount {
  get authentication => null;
}