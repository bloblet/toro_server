import '../models/routerTemplate.dart';

import '../toro_server.dart';

class StockRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/stocks/:symbol')
        .link(() => KeyCheckController())
        .link(() => StockRouter());
  }

  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    final stock = StockDatabase().getStockBySymbol(request.path.variables['symbol']);

    if (stock == null) {
      return Response.notFound();
    }
      
    return Response.ok(stock.toJson());
  }
}
