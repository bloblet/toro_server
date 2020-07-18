import '../models/routerTemplate.dart';

import '../toro_server.dart';

class FollowersRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/:id/followers/[:target]')
        .link(() => KeyCheckController())
        .link(() => FollowersRouter());
  }

  @override
  FutureOr<RequestOrResponse> post(Request request) async {
    final token = request.raw.headers.value('Token');
    final id = request.path.variables['id'];
    final targetID = request.path.variables['target'];

    if (token == null || targetID == null) {
      return Response.badRequest();
    }

    final user = await UserDatabase().getUserByID(id);
    final target = await UserDatabase().getUserByID(targetID);

    if (user.token != token) {
      return Response.forbidden();
    }
    unawaited(UserDatabase().follow(user, target));

    return Response.ok(null);
  }

  @override
  FutureOr<RequestOrResponse> delete(Request request) async {
    final token = request.raw.headers.value('Token');
    final id = request.path.variables['id'];
    final targetID = request.path.variables['target'];

    if (token == null || targetID == null) {
      return Response.badRequest();
    }

    final user = await UserDatabase().getUserByID(id);
    final target = await UserDatabase().getUserByID(targetID);

    if (user.token != token) {
      return Response.forbidden();
    }
    unawaited(UserDatabase().unfollow(user, target));

    return Response.ok(null);
  }

  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    final id = request.path.variables['id'];
    final start = request.path.variables['start'] as int;
    final end = request.path.variables['end'] as int;

    final followers =
        await UserDatabase().getFollowers(id, start: start, end: end);
    return Response.ok(followers);
  }
}
