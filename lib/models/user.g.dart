// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..id = fields[0] as String
      ..token = fields[1] as String
      ..stocks = (fields[2] as Map)?.cast<String, int>()
      ..watchedStocks = (fields[3] as List)?.cast<String>()
      ..balance = fields[4] as double
      ..email = fields[5] as String
      ..username = fields[6] as String
      ..portfolioChanges =
          (fields[7] as Map)?.cast<DateTime, PortfolioChangeEvent>();
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.stocks)
      ..writeByte(3)
      ..write(obj.watchedStocks)
      ..writeByte(4)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.username)
      ..writeByte(7)
      ..write(obj.portfolioChanges);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as String
    ..token = json['token'] as String
    ..stocks = (json['stocks'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as int),
    )
    ..watchedStocks =
        (json['watchedStocks'] as List)?.map((e) => e as String)?.toList()
    ..balance = (json['balance'] as num)?.toDouble()
    ..email = json['email'] as String
    ..username = json['username'] as String
    ..portfolioChanges =
        (json['portfolioChanges'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          DateTime.parse(k),
          e == null
              ? null
              : PortfolioChangeEvent.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'stocks': instance.stocks,
      'watchedStocks': instance.watchedStocks,
      'balance': instance.balance,
      'email': instance.email,
      'username': instance.username,
      'portfolioChanges': instance.portfolioChanges
          ?.map((k, e) => MapEntry(k.toIso8601String(), e)),
    };
