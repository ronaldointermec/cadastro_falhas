import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cadastro_falhas/presentation/pages/edit_failure.dart';
import 'package:cadastro_falhas/presentation/pages/delete_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ValidationFailure extends StatefulWidget {
  const ValidationFailure({Key? key}) : super(key: key);

  @override
  _ValidationFailureState createState() => _ValidationFailureState();
}

class _ValidationFailureState extends State<ValidationFailure> {
  final FailureDAO _failureDAO = FailureDAO();
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _futureData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureData = search();
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> search() async {
    List<DocumentSnapshot<Object?>> rawData =
        await _failureDAO.getAbertoParcial();

    var lista = rawData
        .map((snapshot) =>
            snapshot as QueryDocumentSnapshot<Map<String, dynamic>>)
        .toList();

    var filtrado = lista.where((pn) {
      var pnumber = pn.data()['partNumbers'];
      if (pnumber == null || pnumber is! List) return false;

      for (var i = 0; i < pnumber.length; i++) {
        var aproved = pnumber[i]['aproved'];
        if (aproved != 2) {
          return true;
        }
      }
      return false;
    }).toList();

    filtrado.sort((a, b) {
      var aDate = a.data()['createdAt'];
      var bDate = b.data()['createdAt'];
      if (aDate != null && bDate != null) {
        return bDate.compareTo(aDate);
      }
      return 0;
    });

    return filtrado;
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
                'Aguardando Validação',
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
            onPressed: _loadData,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<
            List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF002B49),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final dataList = snapshot.data!;
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final element = dataList[index];
                  FailureRegisterDTO dto =
                      FailureRegisterDTO.fromJson(element.data());
                  
                  int currentId = 0;
                  if (dto.reqId != null) {
                    currentId = int.tryParse(dto.reqId!) ?? (index + 1);
                  } else {
                    currentId = index + 1;
                  }

                  String family = '';
                  if (dto.partNumbers.isNotEmpty) {
                    family = dto.partNumbers.first.family.toString();
                  }

                  String formattedDate = dto.createdAt != null
                      ? DateFormat('dd/MM/yyyy').format(dto.createdAt!)
                      : '';

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
                              color: const Color(0xFF002B49).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.assignment_outlined,
                              color: Color(0xFF002B49),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ID: $currentId  •  Família: $family',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF002B49),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Requisitante: ${dto.requester}',
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFailure(
                                    dto: dto,
                                    docId: element.id,
                                  ),
                                ),
                              ).then((_) => _loadData());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Excluir',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteFailure(
                                    dto: dto,
                                    docId: element.id,
                                  );
                                },
                              ).then((result) {
                                if (result == true) {
                                  _loadData();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Nenhum dado encontrado.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
