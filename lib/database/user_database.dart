import 'dart:math';

import 'package:uuid/uuid.dart';

import '../toro_server.dart';
const maxDiscriminatorValue = 10000;
const double startingBalance = 25000;

class UserDatabase {
  UserDatabase._() {}

  LazyBox<User> get users {
    return HiveUtils.users;
  }

  Box<String> get usernames {
    return HiveUtils.usernames;
  }

  final Random _random = Random.secure();
  final _uuidGenerator = Uuid();
  final _discriminatorGenerator = Random();

  static final UserDatabase _cache = UserDatabase._();

  factory UserDatabase() => _cache;

  /// Gets a user by their ID.
  ///
  /// If the ID is valid, the corresponding user is returned, otherwise, null.
  Future<User> getUserByID(String id) async {
    return await users.get(id);
  }

  /// Creates a new User
  Future<User> create(Future<String> Function() username) async {
    int discriminator = _discriminatorGenerator.nextInt(maxDiscriminatorValue) - 1;
    int i = 0;

    while (usernames.get('$username#$discriminator') != null) {
      ++i;
      if (i == 1000) {
        throw NoMoreDiscriminators();
      }

      discriminator = _discriminatorGenerator.nextInt(maxDiscriminatorValue) - 1;
    }

    final token = const Base64Encoder.urlSafe().convert(List<int>.generate(32, (i) => _random.nextInt(256)));
    final id = _uuidGenerator.v4();

    final user = User()
      ..friends = []
      ..settings = UserSettings()
      ..discriminator = discriminator
      ..balance = startingBalance
      ..id = id
      ..stocks = {}
      ..portfolioChanges = {}
      ..token = token
      ..watchedStocks = []
      ..username = await username();

    unawaited(users.put(id, user));
    unawaited(usernames.put(username, id));
    Search().users.list.add('${user.username}#${user.discriminator}');

    return user;
  }

  Future<void> changeUsername(String username, User user) async {
    Search().users.list.remove(user.username);
    Search().users.list.add(username);
    unawaited(usernames.delete(user.username));
    unawaited(usernames.put(username, user.id));
    user.username = username;
    unawaited(user.save());
  }

  Future<void> deleteUser(User user) async {
    Search().users.list.remove(user.username);
    unawaited(usernames.delete(user.username));
    unawaited(user.delete());
  }

}

class NoMoreDiscriminators implements Exception {}