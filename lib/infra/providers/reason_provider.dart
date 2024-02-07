import 'package:cadastro_falhas/infra/dao/rejection_reason_dao.dart';
import 'package:cadastro_falhas/presentation/dto/rejection_reason_dto.dart';
import 'package:flutter/foundation.dart';

class ReasonProvider extends ChangeNotifier {
  ReasonProvider({required this.data});
  List<String> data;
  final RejectionReasonDAO _dao = RejectionReasonDAO();

  initData() async {
    if (data.isEmpty) {
      var reasons = await _dao.get();

      updateData(reasons.map((e) {
        RejectionReasonDTO dto =
            RejectionReasonDTO.fromJson(e.data() as Map<String, dynamic>);
        return dto.description;
      }).toList());
    }
  }

  updateData(List<String> data) {
    this.data = data;
  }
}
