import '../toro_server.dart';

class RouterTemplate extends Controller {
  FutureOr<RequestOrResponse> post(Request request) async {
    return Response(418, {}, {'short': 'stout'});
  }

  FutureOr<RequestOrResponse> get(Request request) async {
    return Response(418, {}, {'short': 'stout'});
  }

  FutureOr<RequestOrResponse> put(Request request) async {
    return Response(418, {}, {'short': 'stout'});
  }

  FutureOr<RequestOrResponse> delete(Request request) async {
    return Response(418, {}, {'short': 'stout'});
  }

  FutureOr<RequestOrResponse> _run(
      FutureOr<RequestOrResponse> Function(Request) function,
      Request request) async {
    RequestOrResponse res;
    try {
      res = await function(request);
    } catch (exception, trace) {
      severe('Request headers: ${request.raw.headers} \nRequest Body: ${await request.body.decode()}: \nRequest IP: ${request.connectionInfo.remoteAddress} \nPath: ${request.path.string} \nMethod: ${request.method} \nContent Length: ${request.raw.contentLength} \nE: $exception, \nTrace: $trace');
      rethrow;
    }
    return res;
  }

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    switch (request.method) {
      case 'POST':
        return _run(post, request);
        break;
      case 'GET':
        return _run(get, request);
      case 'PUT':
        return _run(put, request);
      case 'DELETE':
        return _run(delete, request);
      default:
        return Response(418, {}, {'short': 'stout'});
    }
  }
}