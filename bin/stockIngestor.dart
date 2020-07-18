import 'package:http/http.dart';

import 'package:toro_server/toro_server.dart';

const markets = [
  'etf',
  'commodity',
  'euronext',
  'nyse',
  'amex',
  'tsx',
  'mutualfund',
  'nasdaq'
];

final List<String> apiKeys = [
  'c51500d1341f6a12ddfe9557245a778a',
  '2942ba41afb6ea2462042c241be29779',
  '450d8d7b1aa2427893080a4915c58342',
  '05800a6da7450cd943be5d99025d3669',
  '1e5d531c65f704ced8fb26eb87273dc4',
  '89a80be22643e5c17d971bd8ec448a7e',
  '559933fcb5801399dcb047a6a2d9ca29',
  '84d11153b25b929f5076910ef6175d07',
  '7bdeb160ee16a785bf25d25c74f5de7a',
  '3d9ea9995b100acac36a7007571b58d7',
  'c541f58ad207669f8c8b5d0d4af4c1ed',
  '0db01507fa94b249b548ae5052dccc52',
  '6cc8cf2ed0607d6e88043ea0324add7b',
  'babd26b9e6a9652d7e85bcf0d4dcdb50',
  '8fb345d8d6822a8ff5d90056ed1c4d39',
  '8fb345d8d6822a8ff5d90056ed1c4d39',
  'e236983a9cd8d3d43409fc31e9efb610',
  'cc2fffa0bd51776093b09053f95009cb',
  '83a8fb7c8a247409e0611df7f6a8376d',
  'aae542eadb8445df4c69c47100409518',
  '223ffdb8a76d90287b2a6b01a1988e54',
  'a252ebf49aa3c931c32679ddb88d8884',
  'ea57246c88ef2e43f2ae1c033c462ae2',
  'c02f5d77206489a8f00daa7b5ce83400',
  '7b88bcc7e7b8f471bde19cd3cdeea276',
  'ce1195f0ea1b4ec74d8d16e0ae417240',
  '715d1a9132fbba32a177b0fa12a4ba08',
  '03cf060c532bcf1b26d1148aa179414a',
  'f747628aeb1e73f3938c5ae978e6e22a',
  '70531643ff9d1f8bc6b4c57a432e4341',
  'bb7ea7026feff9cd6e38497d3c08e6ec'
];

const endpoint = 'https://onesignal.com/api/v1/notifications';
const key = '';

class Notification {
  final String userID;
  final Stock stock;

  Notification({@required this.userID, @required this.stock});
}

class Notifications {
  static const _appID = '';

  static Future<void> send(Notification notification) async {
    final Map<String, dynamic> req = {};
    req['include_external_user_ids'] = [notification.userID];
    req['app_id'] = _appID;
    req['contents'] = {
      'en': '${notification.stock.symbol} is at ${notification.stock.price}!'
    };
    req['headings'] = {'en': 'Stock price alert'};
    req['data'] = {'stock': notification.stock.toJson()};
    req['buttons'] = [
      {'id': 'buy', 'text': 'Buy 1'},
      {'id': 'sell', 'text': 'Sell 1'}
    ];
    await post(endpoint, body: jsonEncode(req), headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Basic $key'
    });
  }
}

final List<Map<String, Stock>> gottenMarkets = [];
const stockUrl = 'https://fmpcloud.io/api/v3/quotes/{market}?apikey=';

Future<void> getMarket(String market) async {
  dynamic response;
  while (stockUrl == stockUrl) {
    final apiKey = apiKeys.first;

    if (apiKeys.isEmpty) {
      // TODO
    }

    response = jsonDecode(
        (await get('$stockUrl$apiKey'.replaceFirst('{market}', market))).body);

    try {
      final error = response['Error Message'];
      apiKeys.remove(apiKey);
    } catch (_, __) {
      break;
    }
  }

  final Map<String, Stock> stocks = {};

  for (dynamic stock in response) {
    stocks[stock['symbol'] as String] =
        Stock.fromJson(stock as Map<String, dynamic>);
  }

  gottenMarkets.add(stocks);
}

Future<void> main() async {
  Hive.init('hive');
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(StockAdapter());
  final now = DateTime.now();

  await lock();
  HiveUtils.history = await Hive.openLazyBox<Map<String, double>>('history');
  HiveUtils.stocks = await Hive.openBox('stocks');
  HiveUtils.watchedStocks = await Hive.openBox<List<String>>('watchedStocks');

  final Map<String, double> buffer = {};

  HiveUtils.stocks.toMap().forEach((symbol, stock) {
    buffer[symbol as String] = stock.price;
  });

  for (String market in markets) {
    unawaited(getMarket(market).then((_) async {
      if (gottenMarkets.length == markets.length) {
        final nowtime = floorTo15Minutes(now).millisecondsSinceEpoch.toString();

        start = DateTime.now();


        HiveUtils.history.put(nowtime, buffer).then(isDone);
        HiveUtils.stocks.clear().then(isDone);

        gottenMarkets
            .forEach((buffer) => HiveUtils.stocks.putAll(buffer).then(isDone));
      }
    }));
  }
}

DateTime start;
final done = [];

void isDone(_) {
  done.add(_);

  if (done.length == gottenMarkets.length + 2) {
    unlock();
    final end = DateTime.now();
    print('Done!');
    print('Took ${end.difference(start).inMilliseconds}ms');
  }
}

Future<void> lock() async {
  await get('http://localhost:8888/lock');
}

Future<void> unlock() async {
  await get('http://localhost:8888/unlock');
}