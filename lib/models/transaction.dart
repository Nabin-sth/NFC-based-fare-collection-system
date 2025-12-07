import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

enum TransactionType {
  topUp,
  fareDeduction,
  refund,
}

@JsonSerializable()
class Transaction {
  const Transaction({
    required this.id,
    required this.passengerId,
    required this.amount,
    required this.type,
    required this.balanceAfter,
    required this.remarks,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  final String id;
  final String passengerId;
  final double amount;
  final TransactionType type;
  final double balanceAfter;
  final String? remarks;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

