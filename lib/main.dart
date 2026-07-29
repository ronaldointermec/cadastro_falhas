import 'package:cadastro_falhas/firebase_options.dart';
import 'package:cadastro_falhas/infra/providers/family_provider.dart';
import 'package:cadastro_falhas/infra/providers/reason_provider.dart';
import 'package:cadastro_falhas/infra/providers/register_provider.dart';
import 'package:cadastro_falhas/infra/services/global.dart';
import 'package:cadastro_falhas/infra/services/mobile_socket_service.dart';
import 'package:cadastro_falhas/presentation/pages/home.dart';
import 'package:cadastro_falhas/presentation/pages/my_app_test.dart';
import 'package:cadastro_falhas/presentation/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'infra/services/firebase_login_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseFirestore.setLoggingEnabled(true);

  FirebaseAuth.instanceFor(app: app);

  debugPrint('iniciando o main');

  await _performAutoLogin();
  //await _initializeCounter();
  runApp(const MyApp());
  // runApp(const MyAppTest());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider<UserProvider>(
        //     create: (_) => UserProvider(user: null),),
        ChangeNotifierProvider<ReasonProvider>(
          create: (_) => ReasonProvider(
            data: [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MobileSocketService(),
        ),
        ChangeNotifierProvider(
          create: (context) => FamilyProvider(
            data: [],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Cadastro de Falhas',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const Home(),
      ),
    );
  }
}

Future<void> _performAutoLogin() async {
  final FirebaseLoginService loginService = FirebaseLoginService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  if (Global.usuarioAtual == null) {
    debugPrint('Iniciando processo de login');

    await loginService
        .login('cadastrofalhas@honeywell.com', 'honeywellitajuba')
        .then(
      (completed) async {
        if (completed) {
          debugPrint('Sucesso ao realizar login');
        } else {
          debugPrint('Falha ao realizar login.');
        }
      },
    );
  } else {
    debugPrint('Usuário já está logado');
  }
}

// Future<void> _initializeCounter() async {
//   debugPrint('Inicializando o contator');
//   DocumentReference counterRef = FirebaseFirestore.instance.collection('counters').doc('documentCounter');
//
//   DocumentSnapshot snapshot = await counterRef.get();
//   if (!snapshot.exists) {
//     debugPrint('Contator inicializado com sucesso');
//     await counterRef.set({'currentId': 0}); // Initialize to 0
//   }else{
//     debugPrint('O Contator já existe');
//   }
// }
