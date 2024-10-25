import 'package:firebase_auth/firebase_auth.dart';

class Global{

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final usuarioAtual = auth.currentUser;
}