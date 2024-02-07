import 'package:cadastro_falhas/presentation/pages/edit_PartNumber.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_selection.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:flutter/foundation.dart';

class EditFailure extends StatefulWidget {
  EditFailure({required this.dto, required this.docId});

//  final List<PartNumberDTO> partNumbers = List.empty();
  //final String requester = "";
  final String docId;
  final FailureRegisterDTO dto;

  final FailureRegisterDTO _failureRegisterDTO = FailureRegisterDTO(
    requester: '',
    partNumbers: [],
  );
  @override
  _EditFailureState createState() => _EditFailureState();
}

class _EditFailureState extends State<EditFailure> {
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<PartNumberSelectionState> _key =
      GlobalKey<PartNumberSelectionState>();
  late final PartNumberSelection partNumberSelection = PartNumberSelection(
    key: _key,
    onCreate: () {
      setState(() {});
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Falhas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataTable(
                dataRowHeight: 70,
                horizontalMargin: 0,
                headingRowHeight: 70,
                headingTextStyle: TextStyle(
                  fontSize: kIsWeb ? 17 : 11,
                  overflow: TextOverflow.ellipsis,
                ),
                columnSpacing: kIsWeb ? 18 : 4,
                dataTextStyle: const TextStyle(fontSize: kIsWeb ? 16 : 10),
                columns: const [
                  DataColumn(label: Expanded(child: Text('Part Number'))),
                  DataColumn(label: Expanded(child: Text('Classificação'))),
                  DataColumn(label: Expanded(child: Text('Aprovação'))),
                  DataColumn(label: Expanded(child: Text('N° Microsiga'))),
                  DataColumn(label: Expanded(child: Text('Editar'))),
                ],
                rows: widget.dto.partNumbers.map((element) {
                  return DataRow(cells: [
                    DataCell(Text(element.partNumber)),
                    DataCell(Text(element.failureClassification!)),
                    DataCell(Text(element.aproved == true
                        ? "Aprovado"
                        : "Aguardando Aprovação")),
                    DataCell(Text(element.numberMircossiga != null
                        ? element.numberMircossiga!
                        : "Não Informado")),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          PartNumberDTO? editedPartNumber =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPartNumber(
                                dto: widget.dto,
                                docId: widget.docId,
                                index: widget.dto.partNumbers.indexOf(element),
                              ),
                            ),
                          );

                          if (editedPartNumber != null) {
                            setState(() {
                              int index =
                                  widget.dto.partNumbers.indexOf(element);
                              widget.dto.partNumbers[index] = editedPartNumber;
                            });
                          }
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
              if (_key.currentState?.addedPartNumbers.isNotEmpty ?? false)
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            for (var pn
                                in _key.currentState!.addedPartNumbers) {
                              widget._failureRegisterDTO.partNumbers
                                  .add(pn.partNumber);
                            }
                            setState(() {
                              loading = true;
                            });
                          }
                        },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('Salvar edição'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
