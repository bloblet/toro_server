import 'dart:math';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../toro_server.dart';

class Randomizer {
  static final Random _random = Random.secure();

  static String next([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return const Base64Encoder.urlSafe().convert(values);
  }
}

class UserRouter extends Controller implements SubRouter {
  final _uuidGenerator = Uuid();

  @override
  void setup(Router router) {
    router
        .route('/users/[:id]')
        .link(() => KeyCheckController())
        .link(() => this);
  }

  FutureOr<RequestOrResponse> create(Request request) async {
    if (request.body.isEmpty) {
      return Response.badRequest();
    }
    final body = await request.body.decode<Map>();

    if (!body.containsKey('username') || (body['username'] as String).length > 32) {
      return Response.badRequest();
    }

    final id = _uuidGenerator.v4();
    final users = HiveUtils.users;

    final user = User()
      ..balance = 25000
      ..id = id
      ..stocks = []
      ..token = Randomizer.next()
      ..watchedStocks = []
      ..username = body['username'] as String;

    unawaited(users.put(id, user));

    return Response.created(id, body: user.toJson());
  }

  FutureOr<RequestOrResponse> put(Request request) async {
    final id = request.path.variables['id'];
    final token = request.raw.headers.value('Token');

    if (id == null) {
      return Response.badRequest();
    }
    final user = await HiveUtils.users.get(id);

    if (user == null) {
      return Response.notFound();
    }

    if (user.token != token) {
      return Response.unauthorized();
    }

    if (request.body.isEmpty) {
      return Response.badRequest();
    }
    final body = await request.body.decode<Map>();

    if (body.containsKey('username')) user.username = body['username'] as String;
    unawaited(user.save());

    return Response.ok(user.toJson());
  }

  FutureOr<RequestOrResponse> get(Request request) async {
    final id = request.path.variables['id'];
    final token = request.raw.headers.value('Token');

    if (id == null) {
      return Response.badRequest();
    }
    final users = HiveUtils.users;
    final user = await users.get(id);

    if (user == null) {
      return Response.notFound();
    }

    return Response.ok(user.toJson()..removeWhere((key, value) => (key == 'token' || key == 'email') && token != user.token));
  }

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    switch (request.method) {
      case 'POST':
        return create(request);
        break;
      case 'GET':
        return get(request);
      case 'PUT':
        return put(request);
      default:
        return Response(418, {}, {'short': 'stout'});
    }
  }
}
