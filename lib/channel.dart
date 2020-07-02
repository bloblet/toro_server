// import 'package:firebase/firebase.dart';

import 'routes/user.dart';
import 'routes/user.stocks.dart';
import 'toro_server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
///

class ToroServerChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.

  // static Future initializeApplication() async {
  //   initializeApp(
  //       apiKey: "YourApiKey",
  //       authDomain: "YourAuthDomain",
  //       databaseURL: "YourDatabaseUrl",
  //       projectId: "YourProjectId",
  //       storageBucket: "YourStorageBucket");
  // }

  @override
  Future prepare() async {
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

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(StockAdapter());
    Hive.registerAdapter(PortfolioChangeEventAdapter());
    Hive.init('hive');
    HiveUtils.users = await Hive.openLazyBox('users');
    HiveUtils.stocks = await Hive.openBox('stocks');

    stopwatch.stop();
    info('Done initializing!   $bold(${stopwatch.elapsedMilliseconds}ms)');
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // See: https://aqueduct.io/docs/http/request_controller/
    UserRouter().setup(router);
    StocksRouter().setup(router);
    return router;
  }
}
