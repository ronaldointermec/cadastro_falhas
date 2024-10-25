import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';

class DeleteFailure extends StatefulWidget {
  DeleteFailure({required this.dto, required this.docId, this.index});

  final String docId;
  final FailureRegisterDTO dto;
  final int? index;

  @override
  _DeleteFailureState createState() => _DeleteFailureState();
}

class _DeleteFailureState extends State<DeleteFailure> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Excluir Falha?'),
      content: Text('Tem certeza que deseja excluir a falha?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });

            if (widget.index == null) {
              await deleteData(widget.dto, widget.docId);
            } else {
              await deleteItem(widget.dto, widget.docId, widget.index!);
            }

            Navigator.pop(context, true); // Pass 'true' back to indicate deletion was confirmed
          },
          child: loading ? CircularProgressIndicator() : Text('Excluir'),
        ),
      ],
    );
  }

  Future<void> deleteData(FailureRegisterDTO dto, String docId) async {
    final db = FirebaseFirestore.instance.collection('failures');

    try {
      // Delete the document from the Firestore collection
      await db.doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha removida com sucesso')),
      );
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  // Future<void> deleteItem(
  //     FailureRegisterDTO dto, String docId, int index) async {
  //   final db = FirebaseFirestore.instance.collection('failures').doc(docId);
  //
  //   try {
  //     // deleta apenas um item do array partnumber
  //     if (widget.dto.partNumbers.length > 1) {
  //       await db.update({
  //         'partNumbers':
  //             FieldValue.arrayRemove([dto.partNumbers[index].toJson()])
  //       });
  //       // remove o item na lista
  //       widget.dto.partNumbers.removeAt(index);
  //     } else
  //     // se o array só tiver um único elemento, deleta a coleção inteira
  //     if (widget.dto.partNumbers.length == 1) {
  //       await deleteData(widget.dto, widget.docId);
  //       Navigator.pop(context, true);
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Falha removida com sucesso')),
  //     );
  //   } catch (e) {
  //     print('Error deleting document: $e');
  //   }
  // }

  Future<void> deleteItem(FailureRegisterDTO dto, String docId, int index) async {
    final db = FirebaseFirestore.instance.collection('failures').doc(docId);

    try {
      if (widget.dto.partNumbers.length > 1) {
        await db.update({
          'partNumbers': FieldValue.arrayRemove([dto.partNumbers[index].toJson()])
        });
      } else {
        await deleteData(dto, docId); // Delete entire document if it's the last entry
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha removida com sucesso')),
      );

    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
