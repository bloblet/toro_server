import '../models/routerTemplate.dart';

import '../toro_server.dart';

class UserSearchRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/search/:username')
        .link(() => KeyCheckController())
        .link(() => UserSearchRouter());
  }

  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    final username = request.path.variables['username'];

    return Response.ok(UserDatabase().search(username));
  }
}
