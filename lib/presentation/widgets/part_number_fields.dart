import 'package:cadastro_falhas/infra/dao/rejection_reason_dao.dart';
import 'package:cadastro_falhas/infra/providers/family_provider.dart';
import 'package:cadastro_falhas/infra/providers/reason_provider.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:cadastro_falhas/presentation/formatters/uppercase_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/foundation.dart';

List<String> dropDownOptions = ['perda de processo', 'problema de qualidade'];
// List<String> familia = [
//   'Fixo',
//   'IF1',
//   'Portateis',
//   'Scanner',
//   'TAG',
//   'RETRABALHO-ADAPTAÇÃO'
// ];

class PartNumberFields extends StatelessWidget {
  var dateController = TextEditingController();

  PartNumberFields({super.key, required this.onRemove});

  final Function(PartNumberFields) onRemove;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final PartNumberDTO partNumberDTO = PartNumberDTO(
    aproved: ApprovalStatus.Aberto,
    partNumber: '',
    quantity: 0,
    failureClassification: null,
    requestDate: DateTime.now(),
    family: '',
    orderNumber: '',
    rejectionReasonNEW: null,
    observation: '',
    quantityServed: null,
    numberMircossiga: null,
  );

  List<String> data = [];
  final _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  PartNumberDTO get partNumber => partNumberDTO;

  String? _validateField(String? text) {
    if (text == null || text.isEmpty) return 'Campo obrigatório';
    return null;
  }

  final RejectionReasonDAO _dao = RejectionReasonDAO();

  @override
  Widget build(BuildContext context) {
    Provider.of<FamilyProvider>(context).initData();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo item')),
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
                    decoration:
                        const InputDecoration(label: Text('Part number')),
                    inputFormatters: [UppercaseTextFormatter()],
                    controller: _controllers[0],
                    validator: _validateField,
                    onChanged: (text) {
                      partNumberDTO.partNumber = text;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(label: Text('Número da ordem')),
                    inputFormatters: [UppercaseTextFormatter()],
                    controller: _controllers[1],
                    keyboardType: TextInputType.number,
                    validator: _validateField,
                    onChanged: (text) {
                      partNumberDTO.orderNumber = text;
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
                    value: partNumberDTO.failureClassification,
                    onChanged: (option) {
                      partNumberDTO.failureClassification = option!;
                    },
                    validator: _validateField,
                    decoration:
                        const InputDecoration(label: Text('Classificação')),
                  ),
                  // DropdownButtonFormField<String>(
                  //   key: UniqueKey(),
                  //   items: familia
                  //       .map((e) => DropdownMenuItem(
                  //             value: e,
                  //             child: Text(e),
                  //           ))
                  //       .toList(),
                  //   //value: familia,
                  //   onChanged: (option) {
                  //     Provider.of<ReasonProvider>(context, listen: false)
                  //         .reloadData(option ?? 'Fixo');
                  //     partNumberDTO.family = option!;
                  //   },
                  //   validator: _validateField,
                  //   decoration: const InputDecoration(label: Text('Familía')),
                  // ),
                  Consumer<FamilyProvider>(builder: (context, value, child) {
                    List<String> sortedData = List.from(value.data)..sort();

                    return DropdownButtonFormField<String>(
                      key: UniqueKey(),
                      items: sortedData
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      //value: familia,
                      onChanged: (option) {
                        Provider.of<ReasonProvider>(context, listen: false)
                            .reloadData(option ?? 'Fixo');
                        partNumberDTO.family = option!;
                      },
                      validator: _validateField,
                      decoration: const InputDecoration(label: Text('Familía')),
                    );
                  }),
                  Consumer<ReasonProvider>(
                    builder: (context, value, child) {
                      // Ordenar os dados alfabeticamente
                      List<String> sortedData = List.from(value.data)..sort();
                      // print("Sorted data " + sortedData.toString());
                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        key: UniqueKey(),
                        items: sortedData
                            .map((e) => DropdownMenuItem(
                                  value: e.toUpperCase(),
                                  child: Text(e.toUpperCase()),
                                ))
                            .toList(),
                        //value: sortedData[0],
                        onChanged: (option) {
                          partNumberDTO.rejectionReasonNEW = option!;
                        },
                        validator: _validateField,
                        decoration: const InputDecoration(
                          label: Text('Motivo de rejeição'),
                        ),
                      );
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(label: Text('Observações')),
                    inputFormatters: [UppercaseTextFormatter()],
                    controller: _controllers[2],
                    onChanged: (text) {
                      partNumberDTO.observation = text;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(label: Text('Quantidade')),
                    controller: _controllers[3],
                    keyboardType: TextInputType.number,
                    validator: _validateField,
                    onChanged: (text) {
                      partNumberDTO.quantity = int.tryParse(text) ?? 1;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        label: Text('Quantidade atendida')),
                    controller: _controllers[4],
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      partNumberDTO.quantityServed = int.tryParse(text) ?? 0;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text('Data da requisição')),
                    validator: _validateField,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: "##/##/####",
                      )
                    ],
                    onChanged: (text) {
                      partNumberDTO.requestDate =
                          DateFormat('dd/MM/yyyy').parse(text);
                    },
                    initialValue: DateFormat('dd/MM/yyyy')
                        .format(partNumberDTO.requestDate),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context, this);
                        // partNumberDTO.aproved = true;

                        partNumberDTO.aproved = ApprovalStatus.Aberto;
                      }
                    },
                    child: const Text('Adicionar'),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
