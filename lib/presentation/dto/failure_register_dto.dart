import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'failure_register_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class FailureRegisterDTO {
  String requester;
  List<PartNumberDTO> partNumbers;
  String? docId;
  DateTime? createdAt;

  FailureRegisterDTO({required this.requester, required this.partNumbers}) {
    createdAt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }
  factory FailureRegisterDTO.fromJson(Map<String, dynamic> json) =>
      _$FailureRegisterDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FailureRegisterDTOToJson(this);
}
