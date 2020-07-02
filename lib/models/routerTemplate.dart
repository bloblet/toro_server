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

  FutureOr<RequestOrResponse> handle(Request request) {
    switch (request.method) {
      case 'POST':
        return post(request);
        break;
      case 'GET':
        return get(request);
      case 'PUT':
        return put(request);
      case 'DELETE':
        return delete(request);
      default:
        return Response(418, {}, {'short': 'stout'});
    }
  }
}