import '../toro_server.dart';

class KeyCheckController extends Controller {
  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    final key = request.raw.headers.value('Key');
    if (key == null || key != accessToken) {
      warning('${request.connectionInfo.remoteAddress.address} attempted to access ${request.path.string} with an invalid or missing Key header!');
      return Response.serverError();
    }

    return request;
  }
}
