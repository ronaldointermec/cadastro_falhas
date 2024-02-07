// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_number_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartNumberDTO _$PartNumberDTOFromJson(Map<String, dynamic> json) =>
    PartNumberDTO(
      partNumber: json['partNumber'] as String,
      orderNumber: json['orderNumber'] as String,
      requestDate: DateTime.parse(json['requestDate'] as String),
      quantity: json['quantity'] as int,
      rejectionReason: json['rejectionReason'] as String?,
      numberMircossiga: json['numberMircossiga'] as String?,
      aproved: json['aproved'] as bool,
      failureClassification: json['failureClassification'] as String?,
      observation: json['observation'] as String?,
      quantityServed: json['quantityServed'] as int?,
    );

Map<String, dynamic> _$PartNumberDTOToJson(PartNumberDTO instance) =>
    <String, dynamic>{
      'partNumber': instance.partNumber,
      'orderNumber': instance.orderNumber,
      'requestDate': instance.requestDate.toIso8601String(),
      'quantity': instance.quantity,
      'aproved': instance.aproved,
      'quantityServed': instance.quantityServed,
      'observation': instance.observation,
      'failureClassification': instance.failureClassification,
      'rejectionReason': instance.rejectionReason,
      'numberMircossiga': instance.numberMircossiga,
    };
