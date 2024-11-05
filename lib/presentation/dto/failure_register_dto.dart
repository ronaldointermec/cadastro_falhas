import 'package:cadastro_falhas/presentation/dto/part_number_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'failure_register_dto.g.dart';

// final families = [
//   'Fixo',
//   'IF1',
//   'Portateis',
//   'Scanner',
//   'TAG',
//   'Outros',
//   'RETRABALHO-ADAPTAÇÃO'
// ];

@JsonSerializable(explicitToJson: true)
class FailureRegisterDTO {
  String requester;
  List<PartNumberDTO> partNumbers;
  String? docId;
  DateTime? createdAt;
  String? reqId;

  FailureRegisterDTO({
    required this.requester,
    required this.partNumbers,
    this.createdAt,
    this.docId, // Include in constructor
    this.reqId,
  });


  factory FailureRegisterDTO.fromJson(Map<String, dynamic> json) =>
      _$FailureRegisterDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FailureRegisterDTOToJson(this);
}
