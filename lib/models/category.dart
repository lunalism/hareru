import 'package:hive_flutter/hive_flutter.dart';

class Category extends HiveObject {
  final String id;
  final String name;
  final String emoji;
  final String type; // "expense" | "transfer" | "savings" | "income"
  int sortOrder;
  final bool isDefault;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.type,
    required this.sortOrder,
    required this.isDefault,
    required this.createdAt,
  });
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      emoji: fields[2] as String,
      type: fields[3] as String,
      sortOrder: fields[4] as int,
      isDefault: fields[5] as bool,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emoji)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.sortOrder)
      ..writeByte(5)
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.createdAt);
  }
}
