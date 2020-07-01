import 'toro_server.dart';

class HiveUtils {
  static LazyBox<User> get users => Hive.lazyBox('users');
  static Box<Stock> get stocks => Hive.box('stock');

}