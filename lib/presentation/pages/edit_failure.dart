import 'package:cadastro_falhas/presentation/pages/delete_failure.dart';
import 'package:cadastro_falhas/presentation/pages/edit_PartNumber.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_selection.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../infra/services/mobile_socket_service.dart';
import 'package:flutter/foundation.dart';

class EditFailure extends StatefulWidget {
  EditFailure({required this.dto, required this.docId});

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

  int idCounter = 1;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    double paddingValue = (deviceWidth(context) > 600)
        ? deviceWidth(context) * 0.28
        : 16.0; // Adjust according to screen width

    return context.watch<MobileSocketService>().isPrinting
        ? Scaffold(
            appBar: AppBar(
              title: Text('Aguarde o fim da impressão...'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Editar  Falhas'),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  // padding: EdgeInsets.only(left: deviceWidth(context) * 0.28),
                  // padding: EdgeInsets.all(16.0),
                  padding:
                      EdgeInsets.fromLTRB(paddingValue, 16.0, paddingValue, 0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          dataTextStyle:
                              const TextStyle(fontSize: kIsWeb ? 16 : 10),
                          columns: const [
                            DataColumn(label: Expanded(child: Text('ID'))),
                            DataColumn(label: Expanded(child: Text('Família'))),
                            DataColumn(
                                label: Expanded(child: Text('Part Number'))),
                            DataColumn(
                                label: Expanded(child: Text('Classificação'))),
                            DataColumn(
                                label: Expanded(child: Text('Aprovação'))),
                            DataColumn(
                                label: Expanded(child: Text('N° Microsiga'))),
                            DataColumn(label: Expanded(child: Text('Editar'))),
                            DataColumn(label: Expanded(child: Text('Excluir'))),
                          ],
                          rows: widget.dto.partNumbers.isNotEmpty
                              ? widget.dto.partNumbers
                                  .asMap()
                                  .entries
                                  .map((element) {
                                  //int currentId = idCounter++;
                                  // Atribui o ID e incrementa o contador
                                  int currentId = 0;
                                  // use docId como indice, caso docId seja null, cria um indice local
                                  if (widget.dto.reqId! != null) {
                                    currentId =
                                        int.tryParse(widget.dto.reqId!) ??
                                            idCounter++;
                                  } else {
                                    currentId = idCounter++;
                                  }
                                  PartNumberDTO dto = element.value;
                                  int index = element.key;

                                  return DataRow(cells: [
                                    DataCell(Text(currentId.toString())),
                                    DataCell(Text(dto.family.toString())),
                                    DataCell(Text(dto.partNumber)),
                                    DataCell(Text(dto.failureClassification!)),
                                    DataCell(Text(
                                        dto.aproved.toString().split('.')[1])),
                                    DataCell(Text(dto.numberMircossiga != null
                                        ? dto.numberMircossiga!
                                        : "Não Informado")),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          // Push the EditPartNumber screen and wait for the result
                                          PartNumberDTO? editedPartNumber =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPartNumber(
                                                dto: widget.dto,
                                                docId: widget.docId,
                                                index: index,
                                              ),
                                            ),
                                          );

                                          // Check if a part number was returned
                                          if (editedPartNumber != null) {
                                            setState(() {
                                              // Update the part number in the list based on the index
                                              widget.dto.partNumbers[index] =
                                                  editedPartNumber;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DeleteFailure(
                                                dto: widget.dto,
                                                docId: widget.docId,
                                                index: index,
                                              );
                                            },
                                          ).then((result) {
                                            if (result == true) {
                                              setState(() {
                                                widget.dto.partNumbers
                                                    .removeAt(index);
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ]);
                                }).toList()
                              : [
                                  DataRow(cells: [
                                    DataCell(Text('Nehum dado disponível'))
                                  ])
                                  // Fallback for empty list
                                ],
                        ),
                        if (_key.currentState?.addedPartNumbers.isNotEmpty ??
                            false)
                          ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      for (var pn in _key
                                          .currentState!.addedPartNumbers) {
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
                        const SizedBox(
                          height: 24.0,
                        ),
                        !kIsWeb
                            ? IconButton(
                                tooltip: 'Impressão de etiquetas',
                                onPressed: () {
                                  if (widget.dto != null) {
                                    // MobileSocketService sockect =
                                    // MobileSocketService(dto: widget.dto,index: -1);
                                    // sockect.connectToSocket();

                                    context
                                        .read<MobileSocketService>()
                                        .connectToSocket(
                                            dto: widget.dto, index: -1);
                                  }
                                },
                                icon: const Icon(
                                  Icons.print,
                                  size: 60,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
