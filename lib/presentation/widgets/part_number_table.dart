import 'dart:convert';

import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cadastro_falhas/presentation/pages/edit_failure.dart';
import 'package:cadastro_falhas/presentation/pages/delete_failure.dart';

class PartNumberTable extends StatefulWidget {
  const PartNumberTable({super.key, required this.data});

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  @override
  State<PartNumberTable> createState() => _PartNumberTableState();
}

class _PartNumberTableState extends State<PartNumberTable> {
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

        FailureRegisterDTO dto =
            FailureRegisterDTO.fromJson(element.value.data());
        int index = element.key;

                // Atribui o ID e incrementa o contador
        int currentId = 0;
        if (dto.reqId != null) {
          currentId = int.tryParse(dto.reqId!) ?? idCounter++;
        } else {
          currentId = idCounter++;
        }

        return DataRow(cells: [
          DataCell(Text(currentId.toString())),
          // Display the id here
          DataCell(Text(dto.partNumbers.first.family.toString())),
          // Display the id here
          DataCell(Text(dto.requester)),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(dto.createdAt!))),
          DataCell(IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditFailure(
                    dto: dto,
                    docId: element.value.id,
                  ),
                ),
              );
            },
          )),
          DataCell(IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DeleteFailure(
                    dto: dto,
                    docId: element.value.id,
                    //index: index,
                  );
                },
              ).then((result) {
                if (result == true) {
                  setState(() {
                    widget.data.removeAt(index);
                    // widget.dto.partNumbers.removeAt(index);
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
