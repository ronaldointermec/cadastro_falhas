import 'package:cadastro_falhas/infra/providers/user_provider.dart';
import 'package:cadastro_falhas/presentation/pages/export_data.dart';
import 'package:cadastro_falhas/presentation/pages/failure_register_form.dart';
import 'package:cadastro_falhas/presentation/widgets/login_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Falhas'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          LayoutBuilder(builder: (context, constraint) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth:
                      kIsWeb ? constraint.maxWidth * .5 : constraint.maxWidth),
              child: const Image(
                image: AssetImage(
                  'assets/logo.png',
                ),
              ),
            );
          }),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              direction: Axis.vertical,
              runSpacing: 16,
              spacing: 16,
              children: [
                // ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => FailureRegisterForm()));
                //     },
                //     child: const Text('Cadastrar falha')),
                Consumer<UserProvider>(
                  builder: ((context, value, child) {
                    return ElevatedButton(
                        onPressed: () {
                          if (value.user == null) {
                            showDialog(
                                context: context,
                                builder: (context) => LoginDialog());
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FailureRegisterForm()));
                          }
                        },
                        child: const Text('Cadastrar falha'));
                  }),
                ),
                Consumer<UserProvider>(
                  builder: ((context, value, child) {
                    return ElevatedButton(
                        onPressed: () {
                          if (value.user == null) {
                            showDialog(
                                context: context,
                                builder: (context) => LoginDialog());
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExportData()));
                          }
                        },
                        child: const Text('Exportar dados'));
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
