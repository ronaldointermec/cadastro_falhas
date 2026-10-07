import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cadastro_falhas/presentation/pages/edit_failure.dart';
import 'package:cadastro_falhas/presentation/pages/delete_failure.dart';
import 'package:cadastro_falhas/infra/dao/failure_dao.dart';

class PartNumberTable extends StatefulWidget {
  const PartNumberTable({super.key, required this.data});

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  @override
  State<PartNumberTable> createState() => _PartNumberTableState();
}

class _PartNumberTableState extends State<PartNumberTable> {
  final FailureDAO _failureDAO = FailureDAO();
  @override
  Widget build(BuildContext context) {
    int idCounter = 1; // Inicializa o contador de ID

    return DataTable(
      dataTextStyle: const TextStyle(fontSize: kIsWeb ? 16 : 10),
      columns: const [
        DataColumn(label: Expanded(child: Text('ID'))),
        DataColumn(label: Expanded(child: Text('Família'))),
        DataColumn(label: Expanded(child: Text('Requisitante'))),
        DataColumn(label: Expanded(child: Text('Criado em'))),
        DataColumn(label: Expanded(child: Text('Editar'))),
        DataColumn(label: Expanded(child: Text('Excluir'))),
      ],
      rows: widget.data.asMap().entries.map((element) {
        final item = element.value.data();
        int index = element.key;

        // Atribui o ID e incrementa o contador
        int currentId = 0;
        if (item['reqId'] != null) {
          currentId = int.tryParse(item['reqId'].toString()) ?? idCounter++;
        } else {
          currentId = idCounter++;
        }

        return DataRow(cells: [
          DataCell(Text(currentId.toString())),
          // Display the id here
          DataCell(Text(item['family'] ?? '')),
          // Display the id here
          DataCell(Text(item['requester'] ?? '')),
          DataCell(
            Text(
              DateFormat('dd/MM/yyyy').format(
                DateTime.parse(item['createdAt']),
              ),
            ),
          ),
          DataCell(IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final dto = await _failureDAO.getFailureByDocId(item['docId']);

              if (dto == null) {
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditFailure(
                    dto: dto,
                    docId: item['docId'],
                  ),
                ),
              );
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final dto = await _failureDAO.getFailureByDocId(item['docId']);

              if (dto == null) {
                return;
              }

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
                  setState(() {
                    widget.data.removeAt(index);
                  });
                }
              });
            },
          )),
        ]);
      }).toList(),
    );
  }
}
