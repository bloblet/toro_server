import 'package:toro_server/toro_server.dart';

Future run() async {
  Logger.root.level = Level.FINEST;
  final app = Application<ToroServerChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 80;

  const count = 4;
  await app.start(numberOfInstances: count);
  print('Using $count instances');

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}

void main() {
  runZonedGuarded(run, (_,__) {
    severe('E: $_, Trace: $__');
  });
}