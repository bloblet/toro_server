// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_change_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PortfolioChangeEventAdapter extends TypeAdapter<PortfolioChangeEvent> {
  @override
  final typeId = 2;

  @override
  PortfolioChangeEvent read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PortfolioChangeEvent()
      ..oldBalance = fields[0] as double
      ..newBalance = fields[1] as double
      ..portfolioChange = (fields[2] as Map)?.cast<String, int>();
  }

  @override
  void write(BinaryWriter writer, PortfolioChangeEvent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.oldBalance)
      ..writeByte(1)
      ..write(obj.newBalance)
      ..writeByte(2)
      ..write(obj.portfolioChange);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioChangeEvent _$PortfolioChangeEventFromJson(Map<String, dynamic> json) {
  return PortfolioChangeEvent()
    ..oldBalance = (json['oldBalance'] as num)?.toDouble()
    ..newBalance = (json['newBalance'] as num)?.toDouble()
    ..portfolioChange = (json['portfolioChange'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    );
}

Map<String, dynamic> _$PortfolioChangeEventToJson(
        PortfolioChangeEvent instance) =>
    <String, dynamic>{
      'oldBalance': instance.oldBalance,
      'newBalance': instance.newBalance,
      'portfolioChange': instance.portfolioChange,
    };
