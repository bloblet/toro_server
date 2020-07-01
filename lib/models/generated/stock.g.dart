// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../stock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockAdapter extends TypeAdapter<Stock> {
  @override
  final typeId = 1;

  @override
  Stock read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stock()
      ..price = fields[0] as double
      ..symbol = fields[1] as String
      ..name = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, Stock obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.price)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) {
  return Stock()
    ..price = (json['price'] as num)?.toDouble()
    ..symbol = json['symbol'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'price': instance.price,
      'symbol': instance.symbol,
      'name': instance.name,
    };
