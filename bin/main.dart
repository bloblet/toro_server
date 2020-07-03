import 'package:toro_server/toro_server.dart';

Future main() async {
  Logger.root.level = Level.FINEST;
  final app = Application<ToroServerChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8888;

  const count = 4;
  await app.start(numberOfInstances: count);
  print('Using $count instances');

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}