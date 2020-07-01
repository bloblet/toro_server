import 'package:toro_server/toro_server.dart';

Future main() async {

  final app = Application<ToroServerChannel>()
      ..logger.level = Level.FINEST
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  final count = Platform.numberOfProcessors;
  await app.start(numberOfInstances: count);

  fine('Using $count instances');
  info("Application started on port: ${app.options.port}.");
  info("Use Ctrl-C (SIGINT) to stop running the application.");
}