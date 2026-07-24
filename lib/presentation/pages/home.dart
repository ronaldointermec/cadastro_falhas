import 'package:flutter/material.dart';

import 'package:cadastro_falhas/presentation/pages/aproved_failures.dart';
import 'package:cadastro_falhas/presentation/pages/export_data.dart';
import 'package:cadastro_falhas/presentation/pages/failure_register_form.dart';
import 'package:cadastro_falhas/presentation/pages/validation_failure.dart';
import 'package:cadastro_falhas/presentation/widgets/login_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../widgets/custom_drawer.dart';
import '../widgets/ip_dialog.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Registro de falhas'),
      ),
      endDrawer: CustomDrawer(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          LayoutBuilder(builder: (context, constraint) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    kIsWeb ? constraint.maxWidth * 0.5 : constraint.maxWidth,
              ),
              child: Padding(
                  padding: const EdgeInsets.only(top: 130),
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    // width: 300, // Ajuste este valor para o tamanho desejado
                    // fit: BoxFit.fitHeight,
                    height: 120.0,
                  )),
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
                  // Consumer<UserProvider>(
                  //   builder: (context, value, child) {
                  //     return

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await auth.currentUser == null) {
                            showDialog(
                              context: context,
                              builder: (context) => LoginDialog(),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FailureRegisterForm(),
                              ),
                            );
                          }
                        },
                        child: const Text('Cadastrar Falha'),
                      ),
                      const SizedBox(width: 8), // Espaçamento leve
                      ElevatedButton(
                        onPressed: () async {
                          if (await auth.currentUser == null) {
                            showDialog(
                              context: context,
                              builder: (context) => LoginDialog(),
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ValidationFailure()));
                          }
                        },
                        child: const Text('Validação'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await auth.currentUser == null) {
                            showDialog(
                              context: context,
                              builder: (context) => LoginDialog(),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExportData(),
                              ),
                            );
                          }
                        },
                        child: const Text('Exportar dados'),
                      ),
                      const SizedBox(width: 8), // Espaçamento leve
                      ElevatedButton(
                        onPressed: () async {
                          if (await auth.currentUser == null) {
                            showDialog(
                              context: context,
                              builder: (context) => LoginDialog(),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AprovedFailure(),
                              ),
                            );
                          }
                        },
                        child: const Text('Aprovados'),
                      ),
                    ],
                  ),
                  !kIsWeb
                      ? ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Insira o endereço de IP"),
                                  content: IpDialog(),
                                );
                              },
                            );
                          },
                          child: const Text('Configurar Impressora'),
                        )
                      : Container(),
                ]),
          ),
        ],
      ),
    );
  }
}
