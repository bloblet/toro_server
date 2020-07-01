import '../toro_server.dart';

part 'generated/user.g.dart';

@JsonSerializable(createFactory: true)
@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String token;

  @HiveField(2)
  List<Stock> stocks;

  @HiveField(3)
  List<String> watchedStocks;

  @HiveField(4)
  double balance;

  @JsonKey(required: false)
  @HiveField(5)
  String email; // OPTIONAL


  Map<String, dynamic> toJson() => _$UserToJson(this);
}
