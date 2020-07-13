import 'package:fuzzy/fuzzy.dart';

import 'toro_server.dart';


class Search {
  factory Search() => _cache;

  Search._();

  Future<void> init() async {
    users.list.addAll(HiveUtils.usernames.toMap().keys.toList());
    stocks.list.addAll(HiveUtils.stocks.toMap().keys.toList());
  }

  static final _cache = Search._();
  final users = Fuzzy([], options: FuzzyOptions(isCaseSensitive: true));
  final stocks = Fuzzy([], options: FuzzyOptions(isCaseSensitive: false));
}
