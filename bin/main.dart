import 'package:toro_server/toro_server.dart';

Future main() async {

  final app = Application<ToroServerChannel>()
      ..logger.level = Level.FINEST
      ..options.configurationFilePath = "config.yaml"
      ..options.port = 8888;

  // final count = Platform.numberOfProcessors;
  const count = 4;
  await app.start(numberOfInstances: count);

  print('Using $count instances');
  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}