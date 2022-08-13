import 'package:faker/faker.dart';
import 'package:shared/shared.dart';

class PostFactory {
  static Post makeOriginalPost({
    required User author,
  }) =>
      Post.original(
        creationDate: DateTime.now(),
        author: author,
        id: faker.randomGenerator.integer(100),
        text: faker.randomGenerator.string(777),
      );

  static Post makeRepost({
    required User author,
  }) =>
      Post.repost(
        creationDate: DateTime.now(),
        author: author,
        id: faker.randomGenerator.integer(100),
        relatedPost: makeOriginalPost(
            author: User(
          id: faker.randomGenerator.integer(100),
          joinedDate: faker.date.dateTime(),
          username: faker.person.name(),
        )),
      );

  static Post makeQuote({
    required User author,
  }) =>
      Post.quote(
        text: faker.randomGenerator.string(200),
        creationDate: DateTime.now(),
        author: author,
        id: faker.randomGenerator.integer(100),
        relatedPost: makeOriginalPost(
          author: User(
            id: faker.randomGenerator.integer(100),
            joinedDate: faker.date.dateTime(),
            username: faker.person.name(),
          ),
        ),
      );
}
