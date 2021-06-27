import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool googlesigninornot = true;
String emailid = "none";
String uid = "none";
String accesstoken = "none";

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Sign out function.
  Future<void> signOut() async {
    final GoogleSignIn googleSignInObject = GoogleSignIn();
    emailid = "none";
    uid = "none";
    accesstoken = "none";
    googlesigninornot = false;
    await googleSignInObject.signOut();
    await _firebaseAuth.signOut();
  }

  //Sign in with username and password.
  Future<String?> signIn(
      {required String username, required String password}) async {
    try {
      String tempemail = username + "@codebois.com";

      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: tempemail, password: password);

      User currentUser = userCredential.user!;

      //data initiliaze
      emailid = tempemail;
      accesstoken = "none";
      uid = currentUser.uid;
      googlesigninornot = false;

      return "Signed in successfully!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Sign up with email and password.
  Future<String?> signUp(
      {required String username, required String password}) async {
    try {
      String tempemail = username + "@codebois.com";
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: tempemail, password: password);

      User currentUser = userCredential.user!;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.doc(currentUser.uid).set(
        {
          "uid": currentUser.uid,
          "username": username,
          "email": tempemail,
          "googleornot": false,
        },
        SetOptions(merge: true),
      );

      //data initiliaze
      emailid = tempemail;
      accesstoken = "none";
      uid = currentUser.uid;
      googlesigninornot = false;

      return "Signed up successfully!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Sign in with google
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = (await GoogleSignIn(
        scopes: <String>[
          'email',
          'https://mail.google.com/',
        ],
      ).signIn())!;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      googlesigninornot = true;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User currentUser = userCredential.user!;
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.doc(currentUser.uid).set(
        {
          "uid": currentUser.uid,
          "username": currentUser.displayName,
          "email": currentUser.email,
          "googleornot": true,
        },
        SetOptions(merge: true),
      );

      //data initiliaze
      emailid = currentUser.email!;
      uid = currentUser.uid;
      googlesigninornot = true;
      accesstoken = googleAuth.accessToken!;

      return "Signed in successfully!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> refreshToken() async {
    final GoogleSignInAccount googleSignInAccount = (await GoogleSignIn(
      scopes: <String>[
        'email',
        'https://mail.google.com/',
      ],
    ).signInSilently())!;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    accesstoken = googleSignInAuthentication.accessToken!;
  }
}
