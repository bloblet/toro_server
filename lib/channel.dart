// import 'package:firebase/firebase.dart';

import 'routes/user.dart';
import 'routes/user.stocks.dart';
import 'toro_server.dart';
import 'routes/user.avatar.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
///

class ToroServerChannel extends ApplicationChannel {

  Future<void> openBoxes() async {
    Hive.init('hive');

    HiveUtils.users = await Hive.openLazyBox('users');
    HiveUtils.history = await Hive.openLazyBox<Map<String, double>>('history');
    HiveUtils.stocks = await Hive.openBox('stocks');
    HiveUtils.watchedStocks = await Hive.openBox<List<String>>('watchedStocks');
    HiveUtils.usernames = await Hive.openBox<String>('usernames');
  }

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    messageHub.listen((event) async {
      if (event is Map && event["t"] == "unlock") {
        isLocked = false;
        await openBoxes();
        lock.add('');
      } else if (event is Map && event["t"] == "lock") {
        lock = StreamController();
        isLocked = true;
        await Hive.close();
      }
    });

    logger.onRecord.listen((rec) {
      if (rec.level == Level.INFO) {
        print('$infoColor$bold[INFO]$reset $infoColor${rec.message}$reset');
      } else if (rec.level == Level.WARNING) {
        print(
            '$warningColor$bold[WARNING]$reset $warningColor${rec.message}$reset');
      } else if (rec.level == Level.SHOUT) {
        print('$shoutColor$bold[SHOUT]$reset $shoutColor${rec.message}$reset');
      } else if (rec.level == Level.SEVERE) {
        print(
            '$severeColor$bold[SEVERE]$reset $severeColor${rec.message}$reset');
      } else if (rec.level == Level.CONFIG) {
        print(
            '$configColor$bold[CONFIG]$reset $configColor${rec.message}$reset');
      } else if (rec.level == Level.FINE) {
        print('$fineColor$bold[FINE]$reset ${rec.message}');
      } else if (rec.level == Level.FINER) {
        print('$finerColor$bold[INFO]$reset ${rec.message}');
      } else if (rec.level == Level.FINEST) {
        print('$finestColor$bold[INFO]$reset ${rec.message}');
      }
    });

    final stopwatch = Stopwatch()..start();
    Hive.registerAdapter(StockAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(PortfolioChangeEventAdapter());
    Hive.registerAdapter(UserSettingsAdapter());

    await openBoxes();
    await Search().init();

    stopwatch.stop();
    info('Done initializing!   $bold(${stopwatch.elapsedMilliseconds}ms)');
  }

  bool isLocked = false;
  StreamController lock;

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();
    router.route('*').linkFunction((request) async {
      if (isLocked) {
        await lock.stream.first;
      }
      return request;
    });

    router.route('/lock').linkFunction((request) {
      // if (request.connectionInfo.remoteAddress.address == 'localhost') {
        messageHub.add({'t': 'lock'});
        return Response.ok(null);
      // } else {
        // return Response.notFound();
      //}
    });

    router.route('/unlock').linkFunction((request) {
      // if (request.connectionInfo.remoteAddress.address == 'localhost') {
        messageHub.add({'t': 'unlock'});
        return Response.ok(null);
      // } else {
        // return Response.notFound();
      // }
    });

    // See: https://aqueduct.io/docs/http/request_controller/
    UserRouter().setup(router);
    StocksRouter().setup(router);
    AvatarRouter().setup(router);

    return router;
  }
}
