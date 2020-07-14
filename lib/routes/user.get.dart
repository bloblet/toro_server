import '../models/routerTemplate.dart';

import '../toro_server.dart';

class GetUserRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/:username')
        .link(() => KeyCheckController())
        .link(() => GetUserRouter());
  }

  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    final username = request.path.variables['id'];

    final user = await HiveUtils.users.get(username);

    if (user == null) {
      return Response.notFound();
    }

    return Response.ok(user.toJson()..remove('token'));
  }
}