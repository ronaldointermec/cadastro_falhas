import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FailureDAO {
  final CollectionReference failureRef =
      FirebaseFirestore.instance.collection('failures');

  Future<void> create(FailureRegisterDTO failure) async {
    await failureRef.add(failure.toJson()).then((DocumentReference doc) {
      failure.docId = doc.id;
    });
  }

  Future<void> update(FailureRegisterDTO updatedData, String docId) async {
    try {
      await failureRef.doc(docId).update(updatedData.toJson());
    } catch (e) {
      print('Erro ao atualizar dados: $e');
    }
  }

  Future get(DateTime? startDate, DateTime? finalDate) async {
    var failures = await failureRef
        .where('createdAt',
            isGreaterThanOrEqualTo: startDate?.toIso8601String(),
            isLessThanOrEqualTo: finalDate?.toIso8601String())
        .get();
    return failures.docs;
  }
}
