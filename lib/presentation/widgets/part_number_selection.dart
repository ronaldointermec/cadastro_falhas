import 'package:cadastro_falhas/presentation/widgets/part_number_fields.dart';
import 'package:flutter/material.dart';

class PartNumberSelection extends StatefulWidget {
  const PartNumberSelection({super.key, this.onCreate});
  final VoidCallback? onCreate;
  @override
  State<PartNumberSelection> createState() => PartNumberSelectionState();
}

class PartNumberSelectionState extends State<PartNumberSelection> {
  List<PartNumberFields> addedPartNumbers = [];
  List<PartNumberFields> get partNumbers => addedPartNumbers;

  void onRemove(PartNumberFields item) {
    setState(() {
      addedPartNumbers.removeWhere((e) => e.hashCode == item.hashCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              var itemToAdd = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PartNumberFields(onRemove: onRemove)));

              setState(() {
                if (itemToAdd != null) {
                  addedPartNumbers.add(itemToAdd);
                }
                if (widget.onCreate != null) widget.onCreate!();
              });
            },
            child: const Text('Cadastrar novo PN')),
      ],
    );
  }
}
