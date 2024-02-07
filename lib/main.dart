import 'package:cadastro_falhas/firebase_options.dart';
import 'package:cadastro_falhas/infra/providers/reason_provider.dart';
import 'package:cadastro_falhas/infra/providers/user_provider.dart';
import 'package:cadastro_falhas/presentation/pages/home.dart';
import 'package:cadastro_falhas/presentation/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instanceFor(app: app);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(user: null)),
        ChangeNotifierProvider<ReasonProvider>(
            create: (_) => ReasonProvider(data: []))
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
