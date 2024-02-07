import 'dart:convert';

import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cadastro_falhas/presentation/pages/edit_failure.dart';

class PartNumberTable extends StatelessWidget {
  const PartNumberTable({super.key, required this.data});
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> data;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: const [
          DataColumn(label: Expanded(child: Text('Requisitante'))),
          DataColumn(label: Expanded(child: Text('Criado em'))),
          DataColumn(label: Expanded(child: Text('Editar'))),
        ],
        rows: data.map((element) {
          FailureRegisterDTO dto = FailureRegisterDTO.fromJson(element.data());

          return DataRow(cells: [
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
                            docId: element.id
                            )
                      )
                    );
              },
            )),
          ]);
        }).toList());
  }
}
