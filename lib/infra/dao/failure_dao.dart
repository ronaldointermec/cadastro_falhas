import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';

class FailureDAO {
  final CollectionReference failureRef =
      FirebaseFirestore.instance.collection('failures');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(FailureRegisterDTO failure) async {
    final DocumentReference counterRef =
        _firestore.collection('counters').doc('documentCounter');

    try {
      // Start the transaction
      await _firestore.runTransaction((transaction) async {
        print('Transaction started');

        // Get the document snapshot
        DocumentSnapshot snapshot = await transaction.get(counterRef);
        print('Document snapshot retrieved: ${snapshot.exists}');

        if (snapshot.exists) {
          // Increment the currentId
          int newId = (snapshot['currentId'] ?? 0) +
              1; // Ensuring it defaults to 0 if null
          print('New ID calculated: $newId');

          // Update the document
          transaction.update(counterRef, {'currentId': newId});
          print('Counter updated successfully');

          // Create a new failure document
          failure.reqId = newId.toString();

          bool hasApproved = failure.partNumbers.any(
            (pn) => pn.aproved == ApprovalStatus.Aprovado,
          );

          await failureRef.add(failure.toJson()).then(
            (DocumentReference doc) async {
              await _firestore.collection('failures_list').doc(doc.id).set({
                'docId': doc.id,
                'reqId': newId.toString(),
                'requester': failure.requester,
                'createdAt': failure.createdAt?.toIso8601String(),
                'family': failure.partNumbers.isNotEmpty
                    ? failure.partNumbers.first.family
                    : '',
                'hasApproved': hasApproved,
              });

              print('Failure document created with ID: ${doc.id}');
            },
          );
        } else {
          print('Error: Counter document does not exist.');
        }
      });
    } catch (error, stackTrace) {
      print('Error occurred during transaction: $error');
      print('Stack trace: $stackTrace');

      if (error is FirebaseException) {
        print('Firebase error: ${error.message}');
      } else {
        print('Unexpected error: ${error.toString()}');
      }
    }
  }

  Future<void> migrateFailureList() async {
    print('MIGRACAO INICIADA');

    var failures = await failureRef.get();

    print('REGISTROS ENCONTRADOS: ${failures.docs.length}');

    int contador = 0;

    for (var doc in failures.docs) {
      contador++;

      FailureRegisterDTO dto =
          FailureRegisterDTO.fromJson(doc.data() as Map<String, dynamic>);

      bool hasApproved = dto.partNumbers.any(
        (pn) => pn.aproved == ApprovalStatus.Aprovado,
      );

      await _firestore.collection('failures_list').doc(doc.id).set(
        {
          'docId': doc.id,
          'reqId': dto.reqId,
          'requester': dto.requester,
          'createdAt': dto.createdAt?.toIso8601String(),
          'family':
              dto.partNumbers.isNotEmpty ? dto.partNumbers.first.family : '',
          'hasApproved': hasApproved,
        },
        SetOptions(merge: true),
      );

      if (contador % 100 == 0) {
        print('PROCESSADOS: $contador');
      }
    }

    print('MIGRACAO CONCLUIDA');
  }

  Future<void> update(FailureRegisterDTO updatedData, String docId) async {
    print('Atualiza falha no banco');
    try {
      await failureRef.doc(docId).update(updatedData.toJson());

      bool hasApproved = updatedData.partNumbers.any(
        (pn) => pn.aproved == ApprovalStatus.Aprovado,
      );

      await _firestore.collection('failures_list').doc(docId).set({
        'docId': docId,
        'reqId': updatedData.reqId,
        'requester': updatedData.requester,
        'createdAt': updatedData.createdAt?.toIso8601String(),
        'family': updatedData.partNumbers.isNotEmpty
            ? updatedData.partNumbers.first.family
            : '',
        'hasApproved': hasApproved,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Erros ao atualizar dados: $e');
    }
  }

  Future get(DateTime? startDate, DateTime? finalDate) async {
    print('Filtro por data: Consulta falha no banco');
    var failures = await failureRef
        .where('createdAt',
            isGreaterThanOrEqualTo: startDate?.toIso8601String(),
            isLessThanOrEqualTo: finalDate?.toIso8601String())
        .get();
    return failures.docs;
  }

  Future getAbertoParcial() async {
    print('getAbertoParcial: Consulta falha no banco');
    var failures = await failureRef.get();
    return failures.docs;
  }

  Future getApprovedSummary() async {
    var failures = await _firestore
        .collection('failures_list')
        .where('hasApproved', isEqualTo: true)
        .get();
    return failures.docs;
  }

  Future<FailureRegisterDTO?> getFailureByDocId(String docId) async {
    try {
      var doc = await failureRef.doc(docId).get();

      if (!doc.exists) {
        return null;
      }

      return FailureRegisterDTO.fromJson(
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print('Erro ao recuperar falha: $e');
      return null;
    }
  }
}
