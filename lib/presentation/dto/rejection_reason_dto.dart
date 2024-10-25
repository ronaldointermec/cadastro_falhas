import 'package:json_annotation/json_annotation.dart';

part 'rejection_reason_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class RejectionReasonDTO {
  final String description;
  RejectionReasonDTO({required this.description});

  factory RejectionReasonDTO.fromJson(Map<String, dynamic> json) =>
      _$RejectionReasonDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RejectionReasonDTOToJson(this);
}

