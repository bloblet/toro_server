import 'routes/stocks.dart';
import 'routes/user.avatar.dart';
import 'routes/user.dart';
import 'routes/user.follow.dart';
import 'routes/user.search.dart';
import 'routes/user.stocks.dart';
import 'toro_server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
///

class ToroServerChannel extends ApplicationChannel {
  Future<void> openBoxes() async {
    print("initing users");

    HiveUtils.users = await Hive.openLazyBox('users');
    print("initing history");

    HiveUtils.history = await Hive.openLazyBox<Map<String, double>>('history');
    print("initing stocks");
    HiveUtils.stocks = await Hive.openBox('stocks');
    print("initing watchedstocks");
    HiveUtils.watchedStocks = await Hive.openBox<List<String>>('watchedStocks');
    print("initing usernames");
    HiveUtils.usernames = await Hive.openBox<String>('usernames');
    print('done!');
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
        print('Unlocking!');
        await openBoxes();
        isLocked = false;
        lock.add('');
      } else if (event is Map && event["t"] == "lock") {
        print(Hive.isBoxOpen('stocks'));
        print('Locking!');
        lock = StreamController();
        isLocked = true;
        // await Hive.close();
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
    Hive.init('hive');

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

    router.route('/lock').linkFunction((request) async {
      // if (request.connectionInfo.remoteAddress.address == 'localhost') {
      print('Locking!');
      lock = StreamController();
      isLocked = true;
      await Hive.close();
      messageHub.add({'t': 'lock'});

      return Response.ok(null);
      // } else {
      // return Response.notFound();
      //}
    });

    router.route('/unlock').linkFunction((request) async {
      // if (request.connectionInfo.remoteAddress.address == 'localhost') {
      messageHub.add({'t': 'unlock'});
      await openBoxes();
        isLocked = false;
        lock.add('');
      return Response.ok(null);
      // } else {
      // return Response.notFound();
      // }
    });

    // See: https://aqueduct.io/docs/http/request_controller/
    UserRouter().setup(router);
    StocksRouter().setup(router);
    AvatarRouter().setup(router);
    FollowersRouter().setup(router);
    UserSearchRouter().setup(router);
    StockRouter().setup(router);
    return router;
  }
}
