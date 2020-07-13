import '../models/routerTemplate.dart';

import '../toro_server.dart';

class FriendsRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/:username')
        .link(() => KeyCheckController())
        .link(() => FriendsRouter());
  }

  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    final username = request.path.variables['username'];

    final user = await HiveUtils.users.get(username);
    
    if (user == null) {
      return Response.notFound();
    }

    return Response.ok(user.toJson()..remove('token'));
  }
}