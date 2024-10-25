import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ValidationFailure extends StatefulWidget {
  const ValidationFailure({Key? key}) : super(key: key);

  @override
  _ValidationFailureState createState() => _ValidationFailureState();
}

class _ValidationFailureState extends State<ValidationFailure> {
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
        if (aproved != 2) {
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
        title: const Text('Aguardando Validação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                        scrollDirection: Axis.vertical,
                        child: PartNumberTable(
                          data: snapshot.data!,
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
            ),
          ],
        ),
      ),
    );
  }
}
