import 'package:faker/faker.dart';
import 'package:shared/shared.dart';

class UserFactory {
  static User makeUser() => User(
        joinedDate: faker.date.dateTime(),
        id: faker.randomGenerator.integer(100),
        username: faker.person.name(),
        posts: <Post>[],
      );
}
