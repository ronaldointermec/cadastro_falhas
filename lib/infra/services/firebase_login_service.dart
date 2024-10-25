import 'package:cadastro_falhas/infra/services/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLoginService {
 // FirebaseAuth get _firebase => FirebaseAuth.instance;
  Future<bool> login(String email, String password) async {
    late UserCredential? user;
    try {
      user = await Global.auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      user = null;
    }
    return user != null;
  }
}
