import 'dart:math';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
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
    int discriminator =
        _discriminatorGenerator.nextInt(maxDiscriminatorValue) - 1;
    int i = 0;

    while (usernames.get('$username#$discriminator') != null) {
      ++i;
      if (i == 1000) {
        throw NoMoreDiscriminators();
      }

      discriminator =
          _discriminatorGenerator.nextInt(maxDiscriminatorValue) - 1;
    }

    final token = const Base64Encoder.urlSafe()
        .convert(List<int>.generate(32, (i) => _random.nextInt(256)));
    final id = _uuidGenerator.v4();

    final user = User()
      ..followers = []
      ..following = []
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

  Future<void> setAvatar(Image image, String id) async {
    final root = '/etc/toro/avatars/${id}';

    final blurHash = encodeBlurHash(
      image.getBytes(format: Format.rgba),
      image.width,
      image.height,
    );

    final userAvatarDirectory = Directory.fromUri(Uri(path: root));
    if (!userAvatarDirectory.existsSync()) {
      userAvatarDirectory.createSync();
    }

    unawaited(File.fromUri(
      Uri(path: '$root/avatar.png'),
    ).writeAsBytes(image.getBytes()));
    unawaited(
        File.fromUri(Uri(path: '$root/avatar.sum')).writeAsString(blurHash));
  }

  Future<List<Map<String, dynamic>>> getFollowers(String id,
      {int start = 0, int end = 50}) async {
    final user = await getUserByID(id);
    final List<Map<String, dynamic>> followers = [];
    int startIndex = 0;
    int endIndex = 50;
    if (start >= 0 && start < user.followers.length) {
      startIndex = start;
    }
    if (end < user.followers.length) {
      endIndex = end;
    }

    if (endIndex - startIndex > 100) {
      endIndex = startIndex + 100;
    }

    if (endIndex >= user.followers.length) {
      endIndex = user.followers.length - 1;
    }

    for (String id in user.followers.sublist(startIndex, endIndex)) {
      followers
          .add(Follower.fromJson((await getUserByID(id)).toJson()).toJson());
    }

    return followers;
  }

  Future<void> follow(User user, User target) async {
    if (!target.settings.acceptingFollowers) {
      throw UserNotAcceptingFollowers();
    }

    if (!user.following.contains(target.id) && user.id != target.id) {
      user.following.add(target.id);
      await user.save();
    }
  }

  Future<void> unfollow(User user, User target) async {
    user.following.remove(target.id);
    await user.save();
  }

  Future<List<Map<String, dynamic>>> search(String username) async {
    final results = Search().users.search(username, 50);
    final List<Map<String, dynamic>> usersJson = [];

    for (final result in results) {
      final user = await users.get(result.item);
      usersJson.add({'username': user.username, 'worth': user.balance});
    }
    return usersJson;
  }


}

class NoMoreDiscriminators implements Exception {}
class UserNotAcceptingFollowers implements Exception {}
