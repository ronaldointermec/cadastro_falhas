import 'package:cadastro_falhas/infra/services/firebase_login_service.dart';
import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({Key? key}) : super(key: key);

  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final FirebaseLoginService _loginService = FirebaseLoginService();

  @override
  void initState() {
    super.initState();
    _performAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Não renderiza nenhum widget visualmente
  }

  Future<void> _performAutoLogin() async {
    debugPrint('_performAutoLogin');
    await _loginService
        .login('cadastrofalhas@honeywell.com', 'honeywellitajuba')
        .then((completed) async {
      if (completed) {
        debugPrint('Sucesso ao realizar login');
        // _saveCredentials();
        // Provider.of<UserProvider>(context, listen: false)
        //     .updateUser(FirebaseAuth.instance.currentUser!);
        _showSnackBar('Carregando informações...');
        Navigator.pop(context);
      } else {
        debugPrint('Falha ao realizar login');
        _showSnackBar('Falha no login. Tente novamente.');
      }
    });
  }

  // Future<void> _saveCredentials() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(
  //       'cadastrofalhas@honeywell.com', 'cadastrofalhas@honeywell.com');
  //   prefs.setString('honeywellitajuba', 'honeywellitajuba');
  //   prefs.getString('');
  //
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
