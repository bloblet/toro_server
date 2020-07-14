import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as img;

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
    img.Image image = img.decodeImage(body);

    final blurHash = encodeBlurHash(
      image.getBytes(format: img.Format.rgba),
      image.width,
      image.height,
    );

    final userAvatarDirectory = Directory.fromUri(
        Uri(path: '/etc/toro/avatars/${request.path.variables["id"]}'));
    if (userAvatarDirectory.existsSync()) {
      unawaited(File.fromUri(Uri(
              path:
                  '/etc/toro/avatars/${request.path.variables["id"]}/avatar.png'))
          .writeAsBytes(body));
      unawaited(File.fromUri(Uri(path: '/etc/toro/avatars/${request.path.variables["id"]}/avatar.sum')).writeAsString(blurHash));
    }

    return Response.ok(null);
  }
}
