import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/infra/services/mobile_socket_service.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_selection.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_falhas/infra/providers/reason_provider.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:cadastro_falhas/presentation/formatters/uppercase_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/foundation.dart';

List<String> dropDownOptions = ['perda de processo', 'problema de qualidade'];
List<String> familia = [
  'Fixo',
  'IF1',
  'Portateis',
  'Scanner',
  'TAG',
  'RETRABALHO-ADAPTAÇÃO'
];

class EditPartNumber extends StatefulWidget {
  EditPartNumber({required this.dto, required this.docId, required this.index});

  final FailureRegisterDTO _failureRegisterDTO = FailureRegisterDTO(
    requester: '',
    partNumbers: [],
  );

  final FailureDAO _failureDAO = FailureDAO();
  final FailureRegisterDTO dto;
  final String docId;
  final int index;

  @override
  _EditPartNumberState createState() => _EditPartNumberState();
}

class _EditPartNumberState extends State<EditPartNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isObscure = true;
  bool _showPassword = false;
  TextEditingController _passwordController = TextEditingController();
  ApprovalStatus showAdditionalFields = ApprovalStatus.Aberto;
  TextEditingController keywordController = TextEditingController();

  final GlobalKey<PartNumberSelectionState> _key =
      GlobalKey<PartNumberSelectionState>();

  String? _validateField(String? text) {
    if (text == null || text.isEmpty) return 'Campo obrigatório';
    return null;
  }

  bool loading = false;
  bool isApproved = false;

  @override
  void initState() {
    super.initState();
    debugPrint('State incial');
    Provider.of<ReasonProvider>(context, listen: false)
        .reloadData(widget.dto.partNumbers[widget.index].family!);

    isApproved =
        widget.dto.partNumbers[widget.index].aproved == ApprovalStatus.Aprovado
            ? true
            : false;
  }

  @override
  Widget build(BuildContext context) {
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
            appBar: AppBar(title: const Text('Editar Item')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      TextFormField(
                        enabled: !isApproved,
                        decoration:
                            const InputDecoration(label: Text('Part number')),
                        inputFormatters: [UppercaseTextFormatter()],
                        validator: _validateField,
                        controller: TextEditingController(
                            text: widget
                                .dto.partNumbers[widget.index].partNumber),
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index].partNumber =
                              text;
                        },
                      ),
                      TextFormField(
                        enabled: !isApproved,
                        decoration: const InputDecoration(
                            label: Text('Número da ordem')),
                        inputFormatters: [UppercaseTextFormatter()],
                        controller: TextEditingController(
                            text: widget
                                .dto.partNumbers[widget.index].orderNumber),
                        keyboardType: TextInputType.number,
                        validator: _validateField,
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index].orderNumber =
                              text;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        key: UniqueKey(),
                        items: dropDownOptions
                            .map((e) => DropdownMenuItem(
                                  value: e.toUpperCase(),
                                  child: Text(e.toUpperCase()),
                                ))
                            .toList(),
                        value: widget.dto.partNumbers[widget.index]
                            .failureClassification,
                        onChanged: isApproved
                            ? null
                            : (option) {
                                widget.dto.partNumbers[widget.index]
                                    .failureClassification = option!;
                              },
                        validator: _validateField,
                        decoration:
                            const InputDecoration(label: Text('Classificação')),
                      ),
                      DropdownButtonFormField<String>(
                        key: UniqueKey(),
                        items: familia
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        value:
                            widget.dto.partNumbers[widget.index].family ?? "",
                        onChanged: isApproved
                            ? null
                            : (option) {
                                Provider.of<ReasonProvider>(context,
                                        listen: false)
                                    .reloadData(option ?? 'Fixo');
                                widget.dto.partNumbers[widget.index].family =
                                    option!;
                              },
                        validator: _validateField,
                        decoration:
                            const InputDecoration(label: Text('Famália')),
                      ),
                      Consumer<ReasonProvider>(
                        builder: (context, value, child) {
                          List<String> _sortedData = List.from(value.data)
                            ..sort();
                          return DropdownButtonFormField<String>(
                            isExpanded: true,
                            key: UniqueKey(),
                            //_sortedData.toSet().toList() - remove duplicidade
                            items: _sortedData.toSet().toList().map((e) {
                                  return DropdownMenuItem(
                                    value: e.toUpperCase(),
                                    child: Text(e.toUpperCase()),
                                  );
                                }).toList() ??
                                [],
                            value: widget.dto.partNumbers[widget.index]
                                .rejectionReasonNEW,
                            onChanged: isApproved
                                ? null
                                : (option) {
                                    widget.dto.partNumbers[widget.index]
                                        .rejectionReasonNEW = option!;
                                  },
                            validator: _validateField,
                            decoration: const InputDecoration(
                              label: Text('Motivo de rejeição'),
                            ),
                          );
                        },
                      ),
                      TextFormField(
                        enabled: !isApproved,
                        decoration:
                            const InputDecoration(label: Text('Observações')),
                        inputFormatters: [UppercaseTextFormatter()],
                        controller: TextEditingController(
                            text: widget
                                .dto.partNumbers[widget.index].observation),
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index].observation =
                              text;
                        },
                      ),
                      TextFormField(
                        enabled: !isApproved,
                        decoration:
                            const InputDecoration(label: Text('Quantidade')),
                        controller: TextEditingController(
                            text: widget.dto.partNumbers[widget.index].quantity
                                .toString()),
                        keyboardType: TextInputType.number,
                        validator: _validateField,
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index].quantity =
                              int.tryParse(text) ?? 1;
                        },
                      ),
                      TextFormField(
                        enabled: !isApproved,
                        decoration: const InputDecoration(
                            label: Text('Quantidade atendida')),
                        controller: TextEditingController(
                            text: widget
                                .dto.partNumbers[widget.index].quantityServed
                                .toString()),
                        validator: _validateField,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index].quantityServed =
                              int.tryParse(text) ?? 0;
                        },
                      ),
                      TextFormField(
                        enabled: !isApproved,
                        decoration: const InputDecoration(
                            label: Text('Número Microsiga')),
                        inputFormatters: [UppercaseTextFormatter()],
                        controller: TextEditingController(
                            text: widget
                                .dto.partNumbers[widget.index].numberMircossiga
                                .toString()),
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index]
                              .numberMircossiga = text;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        enabled: false,
                        decoration: const InputDecoration(
                            label: Text('Data da requisição')),
                        validator: _validateField,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: "##/##/####",
                          )
                        ],
                        onChanged: (text) {
                          widget.dto.partNumbers[widget.index].requestDate =
                              DateFormat('dd/MM/yyyy').parse(text);
                          debugPrint(
                              'Data: ${widget.dto.partNumbers[widget.index].requestDate}');
                        },
                        controller: TextEditingController(
                          text: DateFormat('dd/MM/yyyy')
                              .format(widget.dto.createdAt!),
                        ),
                      ),
                      TextFormField(
                        enabled: !isApproved,
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: 'Aprovar cadastro',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (text) {
                          setState(() {
                            if (text == 'teste') {
                              showAdditionalFields = ApprovalStatus.Parcial;
                            } else if (text == 'teste123') {
                              showAdditionalFields = ApprovalStatus.Aprovado;
                            } else {
                              showAdditionalFields = ApprovalStatus.Invalido;
                            }
                          });
                        },
                      ),
                      if (showAdditionalFields == ApprovalStatus.Parcial ||
                          showAdditionalFields == ApprovalStatus.Aprovado)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            child: Wrap(
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              loading =
                                                  false; // Not necessary if pop is successful
                                            });

                                            widget.dto.partNumbers[widget.index]
                                                    .requestDate =
                                                DateTime.parse(DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(DateTime.now()));
                                            if (showAdditionalFields ==
                                                ApprovalStatus.Parcial) {
                                              widget
                                                      .dto
                                                      .partNumbers[widget.index]
                                                      .aproved =
                                                  ApprovalStatus.Parcial;
                                            } else if (showAdditionalFields ==
                                                ApprovalStatus.Aprovado) {
                                              widget
                                                      .dto
                                                      .partNumbers[widget.index]
                                                      .aproved =
                                                  ApprovalStatus.Aprovado;
                                            } else {
                                              widget
                                                      .dto
                                                      .partNumbers[widget.index]
                                                      .aproved =
                                                  ApprovalStatus.Invalido;
                                            }

                                            // await updateData(
                                            //   widget.dto.partNumbers,
                                            //   widget.dto.requester,
                                            //   widget.docId,
                                            //   widget.index,
                                            // );

                                            try {
                                              // Update logic
                                              await updateData(
                                                widget.dto.partNumbers,
                                                widget.dto.requester,
                                                widget.docId,
                                                widget.index,
                                              );
                                              // Success message or redirect logic here
                                            } catch (e) {
                                              // Handle the error, display an error message if necessary
                                              debugPrint(
                                                  'Error updating data: $e');
                                            } finally {
                                              // Ensure loading is reset
                                              setState(() {
                                                loading =
                                                    false; // Stop loading regardless of outcome
                                              });
                                            }

                                            // Return the updated PartNumberDTO
                                            //Navigator.pop(context, widget.dto.partNumbers[widget.index]);
                                          }
                                        },
                                  child: loading
                                      ? const CircularProgressIndicator()
                                      : const Text('Salvar cadastro'),
                                )
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      !kIsWeb
                          ? IconButton(
                              tooltip: 'Impressão de etiqueta',
                              onPressed: () {
                                if (widget.index != null &&
                                    widget.dto != null) {
                                  // MobileSocketService sockect = MobileSocketService(
                                  //     dto: widget.dto, index: widget.index);
                                  context
                                      .read<MobileSocketService>()
                                      .connectToSocket(
                                          dto: widget.dto, index: widget.index);
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
          );
  }

  Future<void> updateData(List<PartNumberDTO> lista, String requester,
      String docId, int index) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      FailureRegisterDTO updatedData =
          FailureRegisterDTO(requester: requester, partNumbers: lista);

      await widget._failureDAO.update(updatedData, docId);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alterações'),
            content: Text('Alterações salvas com sucesso.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.pop(context, widget.dto.partNumbers[widget.index]);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      setState(() {
        loading = false;
      });
    }
  }
}
