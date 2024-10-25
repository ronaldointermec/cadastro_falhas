// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_number_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartNumberDTO _$PartNumberDTOFromJson(Map<String, dynamic> json) =>
    PartNumberDTO(
      partNumber: json['partNumber'] as String ?? '',
      orderNumber: json['orderNumber'] as String ?? '',
      requestDate: DateTime.parse(json['requestDate'] as String  ?? ''),
      quantity: json['quantity'] as int ?? 0,
      family: json['family'] as String  ?? '',
      rejectionReasonNEW: json['rejectionReasonNEW'] as String?  ?? '',
      numberMircossiga: json['numberMircossiga'] as String?  ?? '',
      aproved: ApprovalStatus.fromInt( json['aproved'] as int ?? 0),
      failureClassification: json['failureClassification'] as String?  ?? '',
      observation: json['observation'] as String?  ?? '',
      quantityServed: json['quantityServed'] as int?  ?? 0,
    );

Map<String, dynamic> _$PartNumberDTOToJson(PartNumberDTO instance) =>
    <String, dynamic>{
      'partNumber': instance.partNumber,
      'orderNumber': instance.orderNumber,
      'requestDate': instance.requestDate.toIso8601String(),
      'quantity': instance.quantity,
      'aproved': instance.aproved.toInt(),
      'quantityServed': instance.quantityServed,
      'observation': instance.observation,
      'family': instance.family,
      'failureClassification': instance.failureClassification,
      'rejectionReasonNEW': instance.rejectionReasonNEW,
      'numberMircossiga': instance.numberMircossiga,
    };
