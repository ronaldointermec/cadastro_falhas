import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier{
  UserProvider({required this.user});
  User? user;

  updateUser(User credential){
    user = credential;

  }
}