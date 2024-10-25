// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failure_register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FailureRegisterDTO _$FailureRegisterDTOFromJson(Map<String, dynamic> json) =>
    FailureRegisterDTO(
      requester: json['requester'] as String ?? '',
      partNumbers: (json['partNumbers'] as List<dynamic>)
          .map((e) => PartNumberDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(
              json['createdAt'] as String,
            ),
      docId: json['docId'] as String? ?? '',
      reqId: json['reqId'] as String? ?? '',
    );
      // ..docId = json['docId'] as String?;
      // ..createdAt = json['createdAt'] == null
      //     ? null
      //     : DateTime.parse(json['createdAt'] as String);

Map<String, dynamic> _$FailureRegisterDTOToJson(FailureRegisterDTO instance) =>
    <String, dynamic>{
      'requester': instance.requester,
      'partNumbers': instance.partNumbers.map((e) => e.toJson()).toList(),
      if (instance.docId != null) 'docId': instance.docId,
      if (instance.createdAt != null)
        'createdAt': instance.createdAt?.toIso8601String(),
      if(instance.reqId !=null) 'reqId':instance.reqId
    };
