import '../models/routerTemplate.dart';

import '../toro_server.dart';

class StocksRouter extends RouterTemplate implements SubRouter {
  @override
  void setup(Router router) {
    router
        .route('/users/:id/stocks[/:symbol/[:quantity]]')
        .link(() => KeyCheckController())
        .link(() => StocksRouter());
  }

  @override
  FutureOr<RequestOrResponse> post(Request request) async {
    // Get variables from the request
    // This if is at the top because we dont need anything else to check this, so for performance
    // we should check it before we do unneeded things.
    final quantity = int.tryParse(request.path.variables['quantity']);
    if (quantity <= 0) {
      return Response.badRequest();
    }

    final id = request.path.variables['id'];
    final symbol = request.path.variables['symbol'];
    final token = request.raw.headers.value('Token');


    if (symbol == null || quantity == null) {
      return Response.badRequest();
    }
    // The reason i dont group this and the user check is just because getting a user means
    // loading it into memory, so if possible, reduce the times we have to do that.
    final stock = HiveUtils.stocks.get(symbol);
    if (stock == null) {
      return Response.notFound();
    }

    final user = await HiveUtils.users.get(id);
    if (user == null || user.token != token) {
      return Response.notFound();
    }

    if (user.balance < stock.price * quantity) {
      return Response.badRequest();
    }

    if (user.stocks.containsKey(symbol)) {
      user.stocks[symbol] += quantity;
    } else {
      user.stocks[symbol] = quantity;
    }

    final changeEvent = PortfolioChangeEvent()..oldBalance = user.balance ..portfolioChange = {symbol: quantity};
    user.balance -= stock.price * quantity;
    changeEvent.newBalance = user.balance;

    user.portfolioChanges[DateTime.now()] = changeEvent;

    unawaited(user.save());
    final stocks = {};

    user.stocks.forEach((symbol, quantity) {
      final stockObject = HiveUtils.stocks.get(symbol);

      stockObject.quantity = quantity;

      stocks[stockObject.symbol] = stockObject.toJson();
    });

    return Response.ok(stocks);
  }

  @override
  FutureOr<RequestOrResponse> get(Request request) async {
    // Get variables from the request
    // This if is at the top because we dont need anything else to check this, so for performance
    // we should check it before we do uneeded things.
    final id = request.path.variables['id'];
    final symbol = request.path.variables['symbol'];
    final token = request.raw.headers.value('Token');

    // loading it into memory, so if possible, reduce the times we have to do that.

    final user = await HiveUtils.users.get(id);
    if (user == null) {
      return Response.notFound();
    }

    if (user.token != token) {
      return Response.notFound();
    }

    if (symbol != null && !user.stocks.containsKey(symbol)) {
      return Response.notFound();
    }

    final stocks = {};

    user.stocks.forEach((symbol, quantity) {
      final stockObject = HiveUtils.stocks.get(symbol);

      stockObject.quantity = quantity;

      stocks[stockObject.symbol] = stockObject.toJson();
    });

    return Response.ok(stocks);
  }

  @override
  FutureOr<RequestOrResponse> delete(Request request) async{
    // Get variables from the request
    // This if is at the top because we dont need anything else to check this, so for performance
    // we should check it before we do uneeded things.
    final quantity = int.tryParse(request.path.variables['quantity']);
    if (quantity <= 0) {
      return Response.badRequest();
    }

    final id = request.path.variables['id'];
    final symbol = request.path.variables['symbol'];
    final token = request.raw.headers.value('Token');

    if (symbol == null || quantity == null) {
      return Response.badRequest();
    }

    // The reason i dont group this and the user check is just because getting a user means
    // loading it into memory, so if possible, reduce the times we have to do that.
    final stock = HiveUtils.stocks.get(symbol);
    if (stock == null) {
      return Response.notFound();
    }

    final user = await HiveUtils.users.get(id);
    if (user == null) {
      return Response.notFound();
    }

    if (user.token != token) {
      return Response.notFound();
    }

    if (!user.stocks.containsKey(symbol)) {
      return Response.notFound();
    }

    if (user.stocks[symbol] < quantity) {
      return Response.badRequest();
    }

    // Adds it to their portfolio
    if (user.stocks[symbol] == quantity) {
      user.stocks.remove(symbol);
    } else {
      user.stocks[symbol] -= quantity;
    }

    // We log whenever a user's portfolio changes
    final changeEvent = PortfolioChangeEvent()..oldBalance = user.balance ..portfolioChange = {symbol: -quantity};
    user.balance += stock.price * quantity;
    changeEvent.newBalance = user.balance;

    user.portfolioChanges[DateTime.now()] = changeEvent;

    // Save.  This doesnt need to be awaited, since it can finish whenever.
    unawaited(user.save());

    // To avoid making another request to get the portfolio, we can return it right here.
    final stocks = {};

    user.stocks.forEach((symbol, quantity) {
      final stockObject = HiveUtils.stocks.get(symbol);

      stockObject.quantity = quantity;

      stocks[stockObject.symbol] = stockObject.toJson();
    });

    return Response.ok(stocks);
  }
}