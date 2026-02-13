import 'package:hive_flutter/hive_flutter.dart';

enum TransactionType { expense, transfer, savings }

class Transaction extends HiveObject {
  final String id;
  final TransactionType type;
  final double amount;
  final String category;
  final String? memo;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    this.memo,
    required this.createdAt,
  });
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 0;

  @override
  TransactionType read(BinaryReader reader) {
    return TransactionType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    writer.writeByte(obj.index);
  }
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Transaction(
      id: fields[0] as String,
      type: fields[1] as TransactionType,
      amount: fields[2] as double,
      category: fields[3] as String,
      memo: fields[4] as String?,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.memo)
      ..writeByte(5)
      ..write(obj.createdAt);
  }
}
