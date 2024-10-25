import 'package:cadastro_falhas/infra/dao/rejection_reason_dao.dart';
import 'package:flutter/foundation.dart';

class ReasonProvider extends ChangeNotifier {
  ReasonProvider({required this.data});

  List<String> data;
  List<String>? problems;
  final RejectionReasonDAO _dao = RejectionReasonDAO();

  initData(String family) async {
    if (data.isEmpty) {
      debugPrint('ReasonProvider: dados iniciais');
      List<String> problems = await _dao.getProblemsForFamily(family);
      updateData(problems);
    }
  }

  reloadData(String family) async {
    debugPrint('ReasonProvider: dados recarregados');
    this.data.clear();
    problems = [];
    problems = await _dao.getProblemsForFamily(family);
    updateData(problems!);
  }

  updateData(List<String> data) {
    debugPrint('ReasonProvider: Dados atualizados');
    this.data = data;
    notifyListeners();
  }
}
