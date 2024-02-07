import 'package:json_annotation/json_annotation.dart';

part 'part_number_dto.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class PartNumberDTO {
  String partNumber, orderNumber;
  DateTime requestDate;
  int quantity;
  bool aproved;
  int? quantityServed;
  String? observation, failureClassification, rejectionReason, numberMircossiga;

  PartNumberDTO(
      {required this.partNumber,
      required this.orderNumber,
      required this.requestDate,
      required this.quantity,
      required this.rejectionReason,
      required this.numberMircossiga,
      required this.aproved,
      required this.failureClassification,
      this.observation,

      this.quantityServed});

  factory PartNumberDTO.fromJson(Map<String, dynamic> json) =>
      _$PartNumberDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PartNumberDTOToJson(this);
}
