import 'package:flutter/foundation.dart';

import '../dao/rejection_familia_dao.dart';

class FamilyProvider extends ChangeNotifier {
  FamilyProvider({required this.data});

  List<String> data;
  List<String>? families;
  final RejectionFamilyDAO _dao = RejectionFamilyDAO();

  initData() async {
    if (data.isEmpty) {
      debugPrint('FamilyProvider: dados iniciais');
      families = [];
      families = await _dao.geFamilies();
      updateData(families!);
    }
  }

  reloadData() async {
    debugPrint('FamilyProvider: dados recarregados');
    this.data.clear();
    families = [];
    families = await _dao.geFamilies();
    updateData(families!);
  }

  updateData(List<String> data) {
    debugPrint('FamilyProvider: Dados atualizados');
    this.data = data;
    notifyListeners();
  }
}
