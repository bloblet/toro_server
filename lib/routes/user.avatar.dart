import 'package:mime/mime.dart';
import 'package:body_parser/body_parser.dart';
import 'package:http_parser/http_parser.dart';

import '../models/routerTemplate.dart';
import '../toro_server.dart';

class AvatarRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/:id/avatar')
        .link(() => KeyCheckController())
        .link(() => AvatarRouter());
  }

  @override
  Future<RequestOrResponse> post(Request request) async {
    final body = await request.raw.asBroadcastStream().single;

    final file = File.fromUri(Uri(path: '/home/matthewfrancis/Desktop/yay.png')).writeAsBytes(body);

    return Response.ok(null);
  }
}