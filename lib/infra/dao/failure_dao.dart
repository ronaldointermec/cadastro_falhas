import 'package:cadastro_falhas/presentation/dto/failure_register_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FailureDAO {
  final CollectionReference failureRef =
      FirebaseFirestore.instance.collection('failures');
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<void> create(FailureRegisterDTO failure) async {
  //   print('cria falha no banco');
  //   await failureRef.add(failure.toJson()).then((DocumentReference doc) {
  //     failure.docId = doc.id;
  //   });
  // }

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
          int newId = (snapshot['currentId'] ?? 0) + 1; // Ensuring it defaults to 0 if null
          print('New ID calculated: $newId');

          // Update the document
          transaction.update(counterRef, {'currentId': newId});
          print('Counter updated successfully');

          // Create a new failure document
          failure.reqId = newId.toString();
          await failureRef.add(failure.toJson()).then((DocumentReference doc) {
            failure.reqId = doc.id; // Set the ID of the new failure document
            print('Failure document created with ID: ${doc.id}');
          });
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
  // Future<void> create(FailureRegisterDTO failure) async {
  //   final DocumentReference counterRef =
  //   _firestore.collection('counters').doc('documentCounter');
  //
  //   try {
  //     // Start transaction
  //     await _firestore.runTransaction((transaction) async {
  //       print('Transaction started');
  //
  //       // Get the document snapshot
  //       DocumentSnapshot snapshot = await transaction.get(counterRef);
  //       print('Document snapshot retrieved: ${snapshot.exists}');
  //
  //       if (snapshot.exists) {
  //         // Increment the ID
  //         int newId = (snapshot['documentCounter'] ?? 0) + 1; // Ensure default if null
  //         print('New ID calculated: $newId');
  //
  //         // Update the document
  //         transaction.update(counterRef, {'documentCounter': newId});
  //         print('Counter updated successfully');
  //
  //         // Create a new failure document
  //         failure.docId = newId.toString();
  //         await failureRef.add(failure.toJson()).then((DocumentReference doc) {
  //           failure.docId = doc.id; // Set the ID of the new failure document
  //           print('Failure document created with ID: ${doc.id}');
  //         });
  //       } else {
  //         print('Error: Counter document does not exist.');
  //       }
  //     });
  //   } catch (error, stackTrace) {
  //     print('Error occurred during transaction: $error');
  //     print('Stack trace: $stackTrace');
  //
  //     // If the error is a FirebaseException
  //     if (error is FirebaseException) {
  //       print('Firebase error: ${error.message}');
  //     } else {
  //       print('Unexpected error: ${error.toString()}');
  //     }
  //   }
  // }

  // Future<void> create(FailureRegisterDTO failure) async {
  //   final DocumentReference counterRef =
  //       _firestore.collection('counters').doc('documentCounter');
  //
  //   // executa a transaction para garantir a leitura e incrementar o contator
  //   await _firestore.runTransaction((transaction) async {
  //     DocumentSnapshot snapshot = await transaction.get(counterRef);
  //     int newId = snapshot['documentCounter'] + 1; // increment o id
  //
  //     //atualiza o contador no documento
  //     transaction.update(counterRef, {'currentId': newId});
  //
  //     // cria um novo documento de falha com o ID incrementado
  //     failure.docId = newId.toString();
  //     await failureRef.add(failure.toJson()).then((DocumentReference doc) {
  //       failure.docId = doc.id;
  //     });
  //   });
  // }

  Future<void> update(FailureRegisterDTO updatedData, String docId) async {
    print('Atualiza falha no banco');
    try {
      await failureRef.doc(docId).update(updatedData.toJson());
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
}
