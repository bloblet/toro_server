import '../models/routerTemplate.dart';

import '../toro_server.dart';

class FriendsRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/:id/friends/:target')
        .link(() => KeyCheckController())
        .link(() => FriendsRouter());
  }

  @override
  FutureOr<RequestOrResponse> post(Request request) async {
    final token = request.raw.headers.value('Token');
    final id = request.path.variables['id'];
    final targetID = request.path.variables['target'];

    if (token == null) {
      return Response.badRequest();
    }

    final user = await HiveUtils.users.get(id);
    final target = await HiveUtils.users.get(targetID);

    if (user.token != token) {
      return Response.forbidden();
    }

  
  }
}