import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<bool> get isLoggedIn {
    return _auth.onAuthStateChanged.map((user) => user != null);
  }

  Future<FirebaseUser> getCurrentUser() async {
    return _auth.currentUser();
  }

  Future<IdTokenResult> getCurrentUserIdToken() async {
    return (await getCurrentUser()).getIdToken();
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    // TODO: handle exceptions thrown by functions
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }
}
