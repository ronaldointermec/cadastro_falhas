import 'package:cloud_firestore/cloud_firestore.dart';

class RejectionReasonDAO {
  final CollectionReference rejectionReasonRef = FirebaseFirestore.instance.collection('rejectionReason');
  Future<List<QueryDocumentSnapshot<Object?>>> get() async{
   var doc =  await rejectionReasonRef.get();
   return doc.docs;
  }
 
}