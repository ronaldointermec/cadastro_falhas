import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Global {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
  static final usuarioAtual = auth.currentUser;
  static final Color backgroundColor = const Color(0xFF002B49); // Brady Blue
  static final String family = 'family';
  static final String rejectionReasonNEW = 'rejectionReasonNEW';
  static final String familia = 'Família';
  static final String backendUrl = "http://hic041474:8096/refurbish";
  static final String appVersion = 'Versão 1.0.0.5 @ Honeywell 2026';
}
