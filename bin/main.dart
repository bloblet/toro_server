import 'package:toro_server/toro_server.dart';

Future main() async {
  final toro = File.fromUri(Uri(path: '/etc/toro'));

  // if (!toro.existsSync()) {
  //   print('Please make a /etc/toro folder, a /etc/toro/avatars folder, and make sure the user toro is running on has permission to read and write');
  //   exit(1);
  // }

  final process = await Process.run('whoami', []);

  if (process.stdout == 'root\n') {
    print('Please do NOT run toro in superuser!!');
  }


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