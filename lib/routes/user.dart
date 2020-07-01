import '../toro_server.dart';

class UserRouter extends Controller implements SubRouter {
  @override
  void setup(Router router) {
    router.route('/users/[:id]').link(() => KeyCheckController()).link(() => this);
  }

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    return Response.ok({'yay': 'yoot'});
  }

}