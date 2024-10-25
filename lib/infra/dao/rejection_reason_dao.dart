import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class RejectionReasonDAO {
  final CollectionReference rejectionReasonRef =
      FirebaseFirestore.instance.collection('rejectionReasonNEW');

  Future<List<String>> getProblemsForFamily(String familyName) async {
    print('getProblemsForFamily');
    List<String> problems = [];

    try {
      DocumentSnapshot familyDoc =
          await rejectionReasonRef.doc('Família').get();

      if (familyDoc.exists) {
        for (String subCollectionName in [familyName]) {
          CollectionReference subCollectionRef =
              familyDoc.reference.collection(subCollectionName);

          QuerySnapshot subCollectionSnapshot = await subCollectionRef.get();

          for (QueryDocumentSnapshot<Object?> doc
              in subCollectionSnapshot.docs) {
            problems.add(doc['description'] as String);
          }
        }
      } else {
        print('Documento da família $familyName não encontrado.');
      }
    } catch (e) {
      print('Erro ao obter tipos de problemas para a família $familyName: $e');
    }

    return problems;
  }
}
