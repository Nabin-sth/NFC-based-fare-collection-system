// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: json['id'] as String,
  passengerId: json['passengerId'] as String,
  amount: (json['amount'] as num).toDouble(),
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  balanceAfter: (json['balanceAfter'] as num).toDouble(),
  remarks: json['remarks'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'passengerId': instance.passengerId,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'balanceAfter': instance.balanceAfter,
      'remarks': instance.remarks,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.topUp: 'topUp',
  TransactionType.fareDeduction: 'fareDeduction',
  TransactionType.refund: 'refund',
};
