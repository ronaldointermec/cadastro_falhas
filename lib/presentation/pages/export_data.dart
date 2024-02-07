import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/infra/services/file_service.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_table.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExportData extends StatefulWidget {
  ExportData({super.key});
  final FailureDAO _failureDAO = FailureDAO();
  final FileService _fileService = FileService();
  @override
  State<ExportData> createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {
  DateTime? startDate, finalDate;
  Future? filter;
  bool isTableVisible = false;
  search() async {
    setState(() {
      isTableVisible = true;
      filter = widget._failureDAO.get(startDate, finalDate);
      if (!kReleaseMode) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exportar dados')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              if (!isTableVisible)
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 8,
                  spacing: 16,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(DateTime.now().year + 3));
                          setState(() {
                            startDate = selectedDate;
                          });
                        },
                        child: Text(startDate == null
                            ? 'Data inicial'
                            : DateFormat('dd/MM/yyyy')
                                .format(startDate!)
                                .toString())),
                    ElevatedButton(
                        onPressed: () async {
                          var selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(DateTime.now().year + 3));
                          setState(() {
                            finalDate = selectedDate;
                          });
                        },
                        child: Text(finalDate == null
                            ? 'Data final'
                            : DateFormat('dd/MM/yyyy')
                                .format(finalDate!)
                                .toString())),
                    ElevatedButton(
                        onPressed: (startDate != null || finalDate != null)
                            ? () {
                                search();
                              }
                            : null,
                        child: const Text('Buscar')),
                  ],
                ),
              if (isTableVisible)
                FutureBuilder(
                    future: filter,
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Expanded(
                            child: Column(
                              children: [
                                Wrap(spacing: 16, children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isTableVisible = false;
                                        });
                                      },
                                      child: const Text('Filtrar novamente')),
                                  ElevatedButton(
                                      onPressed: () {
                                        widget._fileService
                                            .createFailureRegisterCsv(
                                                snapshot.data);
                                      },
                                      child: const Text('Exportar')),
                                ]),
                                const SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: PartNumberTable(data: snapshot.data),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      }
                      return Container();
                    }))
            ],
          ),
        ),
      ),
    );
  }
}
