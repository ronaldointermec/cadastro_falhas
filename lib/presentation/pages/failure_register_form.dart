import 'package:cadastro_falhas/infra/dao/failure_dao.dart';
import 'package:cadastro_falhas/infra/providers/reason_provider.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cadastro_falhas/presentation/formatters/uppercase_formatter.dart';
import 'package:cadastro_falhas/presentation/pages/home.dart';
import 'package:cadastro_falhas/presentation/widgets/part_number_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FailureRegisterForm extends StatefulWidget {
  FailureRegisterForm({super.key});
  final FailureRegisterDTO _failureRegisterDTO =
      FailureRegisterDTO(requester: '', partNumbers: [],);
  final FailureDAO _failureDAO = FailureDAO();

  @override
  State<FailureRegisterForm> createState() => _FailureRegisterFormState();
}

class _FailureRegisterFormState extends State<FailureRegisterForm> {
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
  void initState() {
    super.initState();
    Provider.of<ReasonProvider>(context, listen: false).initData();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Cadastrar falha'),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Requisitante'),
                          inputFormatters: [UppercaseTextFormatter()],
                          onChanged: (text) {
                            widget._failureRegisterDTO.requester = text;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        partNumberSelection,
                        if (_key.currentState != null &&
                            _key.currentState!.addedPartNumbers.isNotEmpty)
                          Expanded(
                            child: SingleChildScrollView(
                              child: FittedBox(
                                child: DataTable(
                                    columnSpacing: 10,
                                    columns: const [
                                      DataColumn(
                                          label: Flexible(
                                              child: Text('Part number'))),
                                      DataColumn(
                                          label: Text('Quantidade'),
                                          numeric: true),
                                      DataColumn(label: Text('Editar')),
                                      DataColumn(label: Text('Excluir')),
                                    ],
                                    rows: _key.currentState!.addedPartNumbers
                                        .map((partNumber) => DataRow(cells: [
                                              DataCell(Text(partNumber
                                                  .partNumber.partNumber)),
                                              DataCell(Text(partNumber
                                                  .partNumber.quantity
                                                  .toString())),
                                              DataCell(IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      partNumber))
                                                      .whenComplete(
                                                          () => setState(
                                                                () => {},
                                                              ));
                                                },
                                              )),
                                              DataCell(IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  setState(() {
                                                    partNumber
                                                        .onRemove(partNumber);
                                                  });
                                                },
                                              )),
                                            ]))
                                        .toList()),
                              ),
                            ),
                          )
                      ],
                    ),
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
                                  await widget._failureDAO
                                      .create(widget._failureRegisterDTO)
                                      .then((value) =>
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Home()),
                                              (route) => false));
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              },
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text('Salvar cadastro'))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
