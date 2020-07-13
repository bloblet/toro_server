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

    final results = Search().users.search(username, 10);
    final usersJson = [];

    for (final result in results) {
      final user = await HiveUtils.users.get(result.item);
      usersJson.add({'username': user.username, 'worth': user.balance});
    }

    return Response.ok(usersJson);
  }
}
