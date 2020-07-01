import 'toro_server.dart';

class HiveUtils {
  static LazyBox<User> users;

  static Box<Stock> get stocks => Hive.box('stock');
}
