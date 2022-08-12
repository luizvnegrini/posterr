import 'package:faker/faker.dart';
import 'package:shared/shared.dart';

class UserFactory {
  static User makeUser({
    List<Post>? posts,
  }) =>
      User(
        joinedDate: faker.date.dateTime(),
        id: faker.randomGenerator.integer(100),
        username: faker.person.name(),
        posts: posts ?? <Post>[],
      );
}
