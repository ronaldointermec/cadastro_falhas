import 'package:json_annotation/json_annotation.dart';

part 'part_number_dto.g.dart';

 enum ApprovalStatus {
    Aberto(0) ,
    Aprovado(2),
    Parcial(1),
    Invalido(99);

    const ApprovalStatus (this.value);
    final int value;

    static ApprovalStatus fromInt (int n) {
      switch (n) {
        case 0:
        return ApprovalStatus.Aberto;
        case 1:
        return ApprovalStatus.Parcial;
        case 2: 
        return ApprovalStatus.Aprovado;
        default:
        return ApprovalStatus.Invalido;
      }
    }

     int toInt (){
      return value;
    }
  }

 

@JsonSerializable(
  explicitToJson: true,
)
class PartNumberDTO {
  String partNumber, orderNumber;
  DateTime requestDate;
  int quantity;
  ApprovalStatus aproved;
  int? quantityServed;
  String? observation, family, failureClassification, numberMircossiga, rejectionReasonNEW;

  PartNumberDTO(
      {required this.partNumber,
      required this.orderNumber,
      required this.requestDate,
      required this.quantity,
      required this.family,
      // required this.rejectionReason,
      required this.rejectionReasonNEW,
      required this.numberMircossiga,
      required this.aproved,
      required this.failureClassification,
      this.observation,

      this.quantityServed});

  factory PartNumberDTO.fromJson(Map<String, dynamic> json) =>
      _$PartNumberDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PartNumberDTOToJson(this);
}
