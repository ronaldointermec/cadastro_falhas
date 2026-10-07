import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AprovedFailure extends StatefulWidget {
  const AprovedFailure({Key? key}) : super(key: key);

  @override
  _AprovedFailureState createState() => _AprovedFailureState();
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> filter() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('failures')
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs;
}

class _AprovedFailureState extends State<AprovedFailure> {
  final FailureDAO _failureDAO = FailureDAO();

  DateTime? startDate, finalDate;

  bool loading = true;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

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

      var filtrado = lista;

      // var filtrado = lista.where((pn) {
      //   var pnumber = pn.data()['partNumbers'];

      //   for (var i = 0; i < pnumber.length; i++) {
      //     var aproved = pnumber[i]['aproved'];

      //     if (aproved == 2) {
      //       return true;
      //     }
      //   }

      //   return false;
      // }).toList();

      filtrado.sort((a, b) {
        var aDate = a.data()['createdAt'];
        var bDate = b.data()['createdAt'];

        if (aDate != startDate && bDate != finalDate) {
          return bDate.compareTo(aDate);
        } else if (aDate == startDate && bDate != finalDate) {
          return 1;
        } else if (aDate != startDate && bDate == finalDate) {
          return -1;
        } else {
          return 0;
        }
      });

      if (mounted) {
        setState(() {
          data = filtrado;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dados Aprovados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: loading
                  ? const Center(
                      child: Text(
                        'Carregando dados...',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : data.isEmpty
                      ? const Center(
                          child: Text('Nenhum dado encontrado.'),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: PartNumberTable(
                              data: data,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
