import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cadastro_falhas/presentation/pages/edit_failure.dart';
import 'package:cadastro_falhas/presentation/pages/home.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_selection.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_table.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_falhas/infra/providers/reason_provider.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:cadastro_falhas/presentation/formatters/uppercase_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

List<String> dropDownOptions = ['perda de processo', 'problema de qualidade'];

class EditPartNumber extends StatefulWidget {
  EditPartNumber({required this.dto, required this.docId, required this.index});

  final FailureRegisterDTO _failureRegisterDTO = FailureRegisterDTO(
    requester: '',
    partNumbers: [],
  );
  // _failureRegisterDTO.partNumbers.add(this.partNumber);
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
  bool showAdditionalFields = false;
  TextEditingController keywordController = TextEditingController();

  final GlobalKey<PartNumberSelectionState> _key =
      GlobalKey<PartNumberSelectionState>();
  String? _validateField(String? text) {
    if (text == null || text.isEmpty) return 'Campo obrigatório';
    return null;
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  decoration: const InputDecoration(label: Text('Part number')),
                  inputFormatters: [UppercaseTextFormatter()],
                  validator: _validateField,
                  controller: TextEditingController(
                      text: widget.dto.partNumbers[widget.index].partNumber),
                  onChanged: (text) {
                    widget.dto.partNumbers[widget.index].partNumber = text;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Número da ordem')),
                  inputFormatters: [UppercaseTextFormatter()],
                  controller: TextEditingController(
                      text: widget.dto.partNumbers[widget.index].orderNumber),
                  keyboardType: TextInputType.number,
                  // controller: _orderNumberController,
                  validator: _validateField,
                  onChanged: (text) {
                    widget.dto.partNumbers[widget.index].orderNumber = text;
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
                  value: widget
                      .dto.partNumbers[widget.index].failureClassification,
                  onChanged: (option) {
                    widget.dto.partNumbers[widget.index].failureClassification =
                        option!;
                  },
                  validator: _validateField,
                  decoration:
                      const InputDecoration(label: Text('Classificação')),
                ),
                Consumer<ReasonProvider>(
                  builder: (context, value, child) {
                    return DropdownButtonFormField<String>(
                      isExpanded: true,
                      key: UniqueKey(),
                      items: value.data
                          .map((e) => DropdownMenuItem(
                                value: e.toUpperCase(),
                                child: Text(e.toUpperCase()),
                              ))
                          .toList(),
                      value:
                          widget.dto.partNumbers[widget.index].rejectionReason,
                      onChanged: (option) {
                        widget.dto.partNumbers[widget.index].rejectionReason =
                            option!;
                      },
                      validator: _validateField,
                      decoration: const InputDecoration(
                          label: Text('Motivo de rejeição')),
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text('Observações')),
                  inputFormatters: [UppercaseTextFormatter()],
                  controller: TextEditingController(
                      text: widget.dto.partNumbers[widget.index].observation),
                  onChanged: (text) {
                    widget.dto.partNumbers[widget.index].observation = text;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(label: Text('Quantidade')),
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
                  decoration:
                      const InputDecoration(label: Text('Quantidade atendida')),
                  controller: TextEditingController(
                      text: widget.dto.partNumbers[widget.index].quantityServed
                          .toString()),
                  validator: _validateField,
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    widget.dto.partNumbers[widget.index].quantityServed =
                        int.tryParse(text) ?? 0;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(label: Text('Número Microsiga')),
                  inputFormatters: [UppercaseTextFormatter()],
                  controller: TextEditingController(
                      text: widget
                          .dto.partNumbers[widget.index].numberMircossiga
                          .toString()),
                  onChanged: (text) {
                    widget.dto.partNumbers[widget.index].numberMircossiga =
                        text;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration:
                      const InputDecoration(label: Text('Data da requisição')),
                  validator: _validateField,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: "##/##/####",
                    )
                  ],
                  onChanged: (text) {
                    widget.dto.partNumbers[widget.index].requestDate =
                        DateFormat('dd/MM/yyyy').parse(text);
                  },
                  controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(
                          widget.dto.partNumbers[widget.index].requestDate)),
                ),
                TextFormField(
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
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      showAdditionalFields = text == 'teste';
                    });
                  },
                ),
                if (showAdditionalFields)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      child: Wrap(
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          // TextFormField(
                          //   decoration: const InputDecoration(
                          //       label: Text('Número Microsiga')),
                          //   inputFormatters: [UppercaseTextFormatter()],
                          //   //controller: widget.partNumber.partNumber,
                          //   onChanged: (text) {
                          //     widget.dto.partNumbers[widget.index]
                          //         .numberMircossiga = text;
                          //   },
                          // ),
                          ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      widget.dto.partNumbers[widget.index]
                                          .aproved = true;
                                      await updateData(
                                          widget.dto.partNumbers,
                                          widget.dto.requester,
                                          widget.docId,
                                          widget.index);
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
                if (!showAdditionalFields)
                  ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await updateData(
                                  widget.dto.partNumbers,
                                  widget.dto.requester,
                                  widget.docId,
                                  widget.index);
                            }
                          },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text('Salvar'),
                  ),
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
      FailureRegisterDTO updatedData = FailureRegisterDTO(
        requester: requester,
        partNumbers: lista,
      );

      await widget._failureDAO.update(updatedData, docId);

      setState(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alterações'),
              content: Text('Alterações salvas com sucesso.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o alerta
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false,
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        loading = false;
      });
    }
  }
}
