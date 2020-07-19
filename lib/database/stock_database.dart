import '../toro_server.dart';

class StockDatabase {
  factory StockDatabase() => _cache;
  StockDatabase._();

  static final StockDatabase _cache = StockDatabase._();

  Box<Stock> get stocks => HiveUtils.stocks;

  Stock getStockBySymbol(String symbol) {
    return stocks.get(symbol);
  }
  
}