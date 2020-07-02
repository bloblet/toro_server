import 'dart:math';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../toro_server.dart';

class Randomizer {
  static final Random _random = Random.secure();

  static String next([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64.encode(values);
  }
}

class UserRouter extends Controller implements SubRouter {
  final uuidGenerator = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  @override
  void setup(Router router) {
    router
        .route('/users/[:id]')
        .link(() => KeyCheckController())
        .link(() => this);
  }

  // FutureOr<RequestOrResponse> create(Request request) async {
  //   assert(request.method == 'POST');

  //   final users = HiveUtils.users;

  //   final id = uuidGenerator.v4();
  //   final user = User()
  //     ..balance = 25000
  //     ..id = id
  //     ..stocks = []
  //     ..token = Randomizer.next()
  //     ..watchedStocks = [];

  //   unawaited(users.put(id, user));

  //   return Response.created(id, body: user.toJson());
  // }

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.ok({'Yay:': 'Indeed'});
  }
}
