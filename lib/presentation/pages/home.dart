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
    }) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 36, color: color),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF002B49),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/brady.png',
              height: 28,
              fit: BoxFit.contain,
            ),
          ],
        ),
        titleSpacing: 16,
      ),
      endDrawer: const CustomDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: kIsWeb ? 950 : 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Painel de Controle',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002B49),
                  ),
                ),
                const SizedBox(height: 24),

                // Cards do Dashboard
                buildDashboardCard(
                  title: 'Cadastrar Falha',
                  subtitle: 'Registrar nova ocorrência ou falha no sistema',
                  icon: Icons.add_circle_outline,
                  color: const Color(0xFF002B49),
                  onTap: () async {
                    if (auth.currentUser == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginDialog(),
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
                ),
                const SizedBox(height: 16),

                buildDashboardCard(
                  title: 'Validação',
                  subtitle: 'Revisar e validar falhas pendentes',
                  icon: Icons.fact_check_outlined,
                  color: Colors.orange.shade800,
                  onTap: () async {
                    if (auth.currentUser == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginDialog(),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ValidationFailure(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                buildDashboardCard(
                  title: 'Aprovados',
                  subtitle: 'Visualizar relatórios de falhas aprovadas',
                  icon: Icons.check_circle_outline,
                  color: Colors.green.shade700,
                  onTap: () async {
                    if (auth.currentUser == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginDialog(),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AprovedFailure(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),

                buildDashboardCard(
                  title: 'Exportar Dados',
                  subtitle: 'Exportar registros por período em CSV',
                  icon: Icons.file_download_outlined,
                  color: Colors.blue.shade700,
                  onTap: () async {
                    if (auth.currentUser == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginDialog(),
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
                ),

                if (!kIsWeb) ...[
                  const SizedBox(height: 16),
                  buildDashboardCard(
                    title: 'Configurar Impressora',
                    subtitle: 'Configurar endereço IP para socket térmico',
                    icon: Icons.print_outlined,
                    color: Colors.purple.shade700,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Insira o endereço de IP"),
                            content: IpDialog(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
