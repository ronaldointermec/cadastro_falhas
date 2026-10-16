import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/presentation/pages/edit_failure.dart';
import 'package:cadastro_falhas/presentation/pages/delete_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AprovedFailure extends StatefulWidget {
  const AprovedFailure({Key? key}) : super(key: key);

  @override
  _AprovedFailureState createState() => _AprovedFailureState();
}

class _AprovedFailureState extends State<AprovedFailure> {
  final FailureDAO _failureDAO = FailureDAO();

  bool loading = true;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

  @override
  void initState() {
    super.initState();
    search();
  }

  void search() async {
    setState(() {
      loading = true;
    });

    try {
      List<DocumentSnapshot<Object?>> rawData =
          await _failureDAO.getApprovedSummary();

      var lista = rawData
          .map((snapshot) =>
              snapshot as QueryDocumentSnapshot<Map<String, dynamic>>)
          .toList();

      lista.sort((a, b) {
        var aDate = a.data()['createdAt'];
        var bDate = b.data()['createdAt'];
        if (aDate != null && bDate != null) {
          return bDate.compareTo(aDate);
        }
        return 0;
      });

      if (mounted) {
        setState(() {
          data = lista;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados aprovados: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/brady.png',
              height: 22,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Dados Aprovados',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: kIsWeb ? 18 : 15),
              ),
            ),
          ],
        ),
        titleSpacing: 12,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: search,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF002B49),
                ),
              )
            : data.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum dado aprovado encontrado.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final element = data[index];
                      final item = element.data();

                      int currentId = 0;
                      if (item['reqId'] != null) {
                        currentId = int.tryParse(item['reqId'].toString()) ?? (index + 1);
                      } else {
                        currentId = index + 1;
                      }

                      String formattedDate = '';
                      if (item['createdAt'] != null) {
                        try {
                          formattedDate = DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(item['createdAt']),
                          );
                        } catch (_) {
                          formattedDate = item['createdAt'].toString();
                        }
                      }

                      bool allApproved = item['allApproved'] == true;

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID: $currentId  •  Família: ${item['family'] ?? ''}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF002B49),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Requisitante: ${item['requester'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Criado em: $formattedDate',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF002B49)),
                                tooltip: 'Editar',
                                onPressed: () async {
                                  final dto = await _failureDAO
                                      .getFailureByDocId(item['docId']);

                                  if (dto == null) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditFailure(
                                        dto: dto,
                                        docId: item['docId'],
                                      ),
                                    ),
                                  ).then((_) => search());
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: allApproved ? Colors.red : Colors.grey,
                                ),
                                tooltip: allApproved ? 'Excluir' : 'Exclusão indisponível (parcial)',
                                onPressed: allApproved
                                    ? () async {
                                        final dto = await _failureDAO
                                            .getFailureByDocId(item['docId']);

                                        if (dto == null) return;

                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteFailure(
                                              dto: dto,
                                              docId: item['docId'],
                                            );
                                          },
                                        ).then((result) {
                                          if (result == true) {
                                            search();
                                          }
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
