import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Global {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  static final usuarioAtual = auth.currentUser;
  static final Color backgroundColor = Colors.lightBlueAccent;
  static final String family = 'family';
  static final String rejectionReasonNEW = 'rejectionReasonNEW';
  static final String familia = 'Família';
}
