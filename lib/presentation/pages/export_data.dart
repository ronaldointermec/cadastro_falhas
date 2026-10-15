import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/infra/services/file_service.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExportData extends StatefulWidget {
  ExportData({Key? key}) : super(key: key);
  final FailureDAO _failureDAO = FailureDAO();
  final FileService _fileService = FileService();

  @override
  State<ExportData> createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {
  DateTime? startDate, finalDate;
  Future? filter;
  bool isTableVisible = false;

  void search() {
    setState(() {
      isTableVisible = true;
      filter = widget._failureDAO.get(startDate, finalDate);
    });
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
                'Exportar dados',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: kIsWeb ? 18 : 15),
              ),
            ),
          ],
        ),
        titleSpacing: 12,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              if (!isTableVisible)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 16,
                      spacing: 16,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF002B49),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                          icon: const Icon(Icons.date_range),
                          onPressed: () async {
                            var picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(DateTime.now().year + 3),
                              initialDateRange: startDate != null && finalDate != null
                                  ? DateTimeRange(start: startDate!, end: finalDate!)
                                  : null,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Color(0xFF002B49),
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                startDate = picked.start;
                                finalDate = picked.end;
                              });
                              // Busca automática imediata ao selecionar o intervalo
                              search();
                            }
                          },
                          label: Text(
                            (startDate == null || finalDate == null)
                                ? 'Selecionar Período de Datas'
                                : '${DateFormat('dd/MM/yyyy').format(startDate!)} até ${DateFormat('dd/MM/yyyy').format(finalDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isTableVisible)
                FutureBuilder(
                  future: filter,
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF002B49),
                          ),
                        ),
                      );
                    } else {
                      if (snapshot.hasData && snapshot.data != null) {
                        final list = snapshot.data as List;
                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.filter_list),
                                    onPressed: () {
                                      setState(() {
                                        isTableVisible = false;
                                        startDate = null;
                                        finalDate = null;
                                      });
                                    },
                                    label: const Text('Alterar Período'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    icon: const Icon(Icons.download),
                                    onPressed: list.isEmpty
                                        ? null
                                        : () async {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => const AlertDialog(
                                                content: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color: Color(0xFF002B49),
                                                    ),
                                                    SizedBox(width: 24),
                                                    Text('Gerando arquivo CSV...'),
                                                  ],
                                                ),
                                              ),
                                            );

                                            try {
                                              await widget._fileService
                                                  .createFailureRegisterCsv(list);
                                              if (mounted) {
                                                Navigator.pop(context); // Fechar loading
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('CSV exportado com sucesso!'),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (mounted) {
                                                Navigator.pop(context); // Fechar loading
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Erro ao exportar CSV: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    label: const Text('Exportar CSV'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: list.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Nenhum registro encontrado no período.',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: PartNumberTable(
                                            data: (list as List<QueryDocumentSnapshot<Map<String, dynamic>>>)
                                                .reversed
                                                .toList(),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const Expanded(
                      child: Center(child: Text('Erro ao carregar dados.')),
                    );
                  }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
