import 'dart:convert';
import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AprovedFailure extends StatefulWidget {
  const AprovedFailure({Key? key}) : super(key: key);

  @override
  _AprovedFailureState createState() => _AprovedFailureState();
}

Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> filter() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('failures')
      .orderBy('createdAt', descending: true)
      .get();
  return snapshot.docs;
}

class _AprovedFailureState extends State<AprovedFailure> {
  final FailureDAO _failureDAO = FailureDAO();
  DateTime? startDate, finalDate;
  late Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> filter =
      Future.value([]);

  void search() async {

  List<DocumentSnapshot<Object?>> rawData =
      await _failureDAO.getAbertoParcial();
  var lista = rawData
      .map((snapshot) =>
          snapshot as QueryDocumentSnapshot<Map<String, dynamic>>)
      .toList();

  var filtrado = lista.where((pn) {
    var pnumber = pn.data()['partNumbers'];
    for (var i = 0; i < pnumber.length; i++) {
      var aproved = pnumber[i]['aproved'];
      if (aproved == 2) {
        return true;
      }
    }
    return false;
  }).toList();

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

  setState(() {
    filter = Future.value(filtrado);
  });
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
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly,
              children: [
                // ElevatedButton(
                //   onPressed: () async {
                //     final selectedDate = await showDatePicker(
                //       context: context,
                //       initialDate: DateTime.now(),
                //       firstDate: DateTime(2000),
                //       lastDate: DateTime.now(),
                //     );
                //     if (selectedDate != null) {
                //       setState(() {
                //         startDate = selectedDate;
                //       });
                //     }
                //   },
                //   child: Text(
                //     startDate == null
                //         ? 'Data inicial'
                //         : DateFormat('dd/MM/yyyy').format(startDate!),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     final selectedDate = await showDatePicker(
                //       context: context,
                //       initialDate: finalDate ?? startDate ?? DateTime.now(),
                //       firstDate: startDate ?? DateTime(2000),
                //       lastDate: DateTime.now(),
                //     );//     if (selectedDate != null) {
                //       setState(() {
                //         finalDate = selectedDate;
                //       });
                //     }
                //   },
                //   child: Text(
                //     finalDate == null
                //         ? 'Data final'
                //         : DateFormat('dd/MM/yyyy').format(finalDate!),
                //   ),
                // ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     search();
            //   },
            //   child: const Text('Buscar'),
            // ),
            Expanded(
              child: FutureBuilder<
                  List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                future: filter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: PartNumberTable(
                          data: snapshot.data!
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Nenhum dado encontrado.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
