import 'package:cadastro_falhas/infra/services/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterDAO {
  Future<String> createFamily({required String family}) async {
    try {
      Global.firebaseInstance.collection(Global.family).add({"name": family});
      return 'Sucesso ao salvar!';
    } on FirebaseException catch (e) {
      debugPrint('Erro ao salvar: ${e.message}');
      return 'Erro ao salvar: ${e.message}';
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String> createReason(
      {required String family, required String reason}) async {
    try {
      Global.firebaseInstance
          .collection(Global.rejectionReasonNEW)
          .doc(Global.familia)
          .collection(family)
          .add({"description": reason});
      return 'Sucesso ao salvar!';
    } on FirebaseException catch (e) {
      debugPrint('Erro ao salvar: ${e.message}');
      return 'Erro ao salvar: ${e.message}';
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      return 'Erro inesperado: $e';
    }
  }
}
