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
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    Widget buildDashboardCard({
      required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
      required bool isDesktop,
    }) {
      return Card(
        elevation: isDesktop ? 4 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24.0 : 14.0,
              vertical: isDesktop ? 20.0 : 10.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: isDesktop ? 36 : 24, color: color),
                ),
                SizedBox(width: isDesktop ? 20 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isDesktop ? 20 : 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF002B49),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 6 : 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: isDesktop ? 18 : 14, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Cadastrar Falha',
        'subtitle': 'Registrar nova ocorrência ou falha no sistema',
        'icon': Icons.add_circle_outline,
        'color': const Color(0xFF002B49),
        'onTap': (BuildContext ctx) async {
          if (auth.currentUser == null) {
            showDialog(
              context: ctx,
              builder: (context) => const LoginDialog(),
            );
          } else {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => FailureRegisterForm()),
            );
          }
        },
      },
      {
        'title': 'Validação',
        'subtitle': 'Revisar e validar falhas pendentes',
        'icon': Icons.fact_check_outlined,
        'color': Colors.orange.shade800,
        'onTap': (BuildContext ctx) async {
          if (auth.currentUser == null) {
            showDialog(
              context: ctx,
              builder: (context) => const LoginDialog(),
            );
          } else {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => const ValidationFailure()),
            );
          }
        },
      },
      {
        'title': 'Aprovados',
        'subtitle': 'Visualizar relatórios de falhas aprovadas',
        'icon': Icons.check_circle_outline,
        'color': Colors.green.shade700,
        'onTap': (BuildContext ctx) async {
          if (auth.currentUser == null) {
            showDialog(
              context: ctx,
              builder: (context) => const LoginDialog(),
            );
          } else {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => const AprovedFailure()),
            );
          }
        },
      },
      {
        'title': 'Exportar Dados',
        'subtitle': 'Exportar registros por período em CSV',
        'icon': Icons.file_download_outlined,
        'color': Colors.blue.shade700,
        'onTap': (BuildContext ctx) async {
          if (auth.currentUser == null) {
            showDialog(
              context: ctx,
              builder: (context) => const LoginDialog(),
            );
          } else {
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (context) => ExportData()),
            );
          }
        },
      },
      {
        'title': 'Configurar Impressora',
        'subtitle': 'Configurar endereço IP para socket térmico',
        'icon': Icons.print_outlined,
        'color': Colors.purple.shade700,
        'onTap': (BuildContext ctx) {
          showDialog(
            context: ctx,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Insira o endereço de IP"),
                content: IpDialog(),
              );
            },
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Image.asset(
          'assets/brady.png',
          height: 28,
          fit: BoxFit.contain,
        ),
        titleSpacing: 16,
      ),
      endDrawer: const CustomDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 24.0 : 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1100 : 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Painel de Controle',
                      style: TextStyle(
                        fontSize: isDesktop ? 26 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF002B49),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 24 : 10),

                    isDesktop
                        ? Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: menuItems.map((item) {
                              return SizedBox(
                                width: 510,
                                child: buildDashboardCard(
                                  title: item['title'],
                                  subtitle: item['subtitle'],
                                  icon: item['icon'],
                                  color: item['color'],
                                  onTap: () => item['onTap'](context),
                                  isDesktop: true,
                                ),
                              );
                            }).toList(),
                          )
                        : Column(
                            children: menuItems.map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: buildDashboardCard(
                                  title: item['title'],
                                  subtitle: item['subtitle'],
                                  icon: item['icon'],
                                  color: item['color'],
                                  onTap: () => item['onTap'](context),
                                  isDesktop: false,
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
