import '../models/routerTemplate.dart';
import '../toro_server.dart';

class UserRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/[:id]')
        .link(() => KeyCheckController())
        .link(() => this);
  }

  /// ## POST
  ///
  /// ### Use: Creates a new user
  ///
  /// ### Fail conditions:
  ///
  /// - Body is empty (`400`)
  /// - Username key isnt in body (`400`)
  /// - Username > 32 characters (`400`)
  /// - No more discriminators (`410`)
  ///
  /// ### Success:
  /// - Status: `201` created
  /// - Body: User JSON
  /// - Headers: Location header as user ID
  @override
  FutureOr<RequestOrResponse> post(Request request) async {
    if (request.body.isEmpty) {
      return Response.badRequest();
    }

    User user;

    try {
      user = await UserDatabase().create(() async {
        final body = await request.body.decode<Map>();

        if (!body.containsKey('username') ||
            (body['username'] as String).length > 32) {
          throw InvalidBody();
        }

        return body['username'] as String;
      });
    } on NoMoreDiscriminators {
      return Response.gone();
    } on InvalidBody {
      return Response.badRequest();
    }

    return Response.created(user.id, body: user.toJson());
  }

  /// ## PUT
  ///
  /// ### Use: Edits a user
  ///
  /// ### Fail conditions:
  ///
  /// - Body is empty (`400`)
  /// - Username > 32 characters (`400`)
  /// - No more discriminators (`410`)
  /// - User does not exist (`404`)
  /// - Body does not contain username (`400`)
  /// 
  /// ### Success:
  /// `200` OK
  @override
  FutureOr<RequestOrResponse> put(Request request) async {
    if (request.body.isEmpty) {
      return Response.badRequest();
    }

    final id = request.path.variables['id'];
    final token = request.raw.headers.value('Token');

    if (id == null) {
      return Response.badRequest();
    }

    final user = await UserDatabase().getUserByID(id);

    if (user == null) {
      return Response.notFound();
    }

    if (user.token != token) {
      return Response.unauthorized();
    }

    final body = await request.body.decode<Map>();

    if (!body.containsKey('username')) {
      return Response.badRequest();
    }

    unawaited(UserDatabase().changeUsername(body['username'] as String, user));

    return Response.ok(user.toJson());
  }

  /// Fail conditions:
  ///
  /// No id (400)
  /// No such user (404)
  ///
  /// Sucess: 200 OK
  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    final id = request.path.variables['id'];
    final token = request.raw.headers.value('Token');

    if (id == null) {
      return Response.badRequest();
    }
    final user = await UserDatabase().getUserByID(id);

    if (user == null) {
      return Response.notFound();
    }

    return Response.ok(user.toJson()
      ..removeWhere((key, value) =>
          (key == 'token' || key == 'email') && token != user.token));
  }

  /// Fail conditions:
  ///
  /// No id (400)
  /// No such user (404)
  /// Invalid token (403)
  ///
  /// Sucess: 200 OK
  @override
  FutureOr<RequestOrResponse> delete(Request request) async {
    final id = request.path.variables['id'];
    final token = request.raw.headers.value('Token');

    if (id == null) {
      return Response.badRequest();
    }
    final user = await UserDatabase().getUserByID(id);

    if (user == null) {
      return Response.notFound();
    }

    if (user.token != token) {
      return Response.forbidden();
    }

    unawaited(UserDatabase().deleteUser(user));

    return Response.ok(null);
  }
}

class InvalidBody implements Exception {}
