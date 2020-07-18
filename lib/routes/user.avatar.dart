import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';

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
    if (request.raw.headers.contentType.primaryType != 'image' ||
        request.raw.headers.contentType.subType != 'png') {
      return Response.badRequest();
    }

    final image = decodeImage(await request.raw.asBroadcastStream().single);

    unawaited(UserDatabase().setAvatar(image, request.path.variables['id']));

    return Response.ok(null);
  }
}
