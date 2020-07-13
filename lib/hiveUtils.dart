import 'toro_server.dart';

class HiveUtils {
  static LazyBox<User> users;

  static Box<Stock> stocks;

  static LazyBox<Map<String, double>> history;

  static Box<List<String>> watchedStocks;

  static Box<String> usernames;
}
