import 'package:faker/faker.dart';
import 'package:shared/shared.dart';

class PostFactory {
  static Post makeOriginalPost(
    User author, {
    DateTime? creationDate,
  }) {
    return Post.original(
      creationDate: creationDate ?? faker.date.dateTime(),
      author: author,
      text: faker.lorem.sentence(),
      id: faker.randomGenerator.integer(100),
    );
  }
}
