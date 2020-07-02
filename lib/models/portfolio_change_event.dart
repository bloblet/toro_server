import '../toro_server.dart';

part 'portfolio_change_event.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class PortfolioChangeEvent {
  @HiveField(0)
  double oldBalance;

  @HiveField(1)
  double newBalance;

  @HiveField(2)
  Map<String, int> portfolioChange;

  double get change => newBalance - oldBalance;
}
