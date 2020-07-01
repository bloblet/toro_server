import '../toro_server.dart';

part 'stock.g.dart';

@JsonSerializable(createFactory: true)
@HiveType(typeId: 1)
class Stock {
  // Maybe factory?
  @JsonKey(ignore: true)
  double _open;

  @JsonKey(ignore: true)
  double _change;

  @JsonKey(ignore: true)
  double _changePercentage;

  @HiveField(0)
  double price;

  @HiveField(1)
  String symbol;

  @HiveField(2)
  String name;

  double get open => _open ??= Hive.box<Map<DateTime, double>>('openHistory')
      .get(symbol)[floor(DateTime.now())];

  double get change => _change ??= price - open;
  double get changePercentage => _changePercentage ??= change / open;

  static Stock fromJson(Map<String, dynamic> json) => _$StockFromJson(json);
  
  Map<String, dynamic> toJson() => _$StockToJson(this);
}
