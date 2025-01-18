import 'package:app/core/extensions.dart';

class UserRepo {
  UserRepo._();
  static UserRepo get instance => UserRepo._();

  String randomName() {
    final funnyFirstNames = ['Funny', 'Crazy', 'Silly', 'Goofy', 'Wacky', 'Zany', 'Loony', 'Nutty', 'Kooky', 'Batty'];
    final funnyLastNames = ['Banana', 'Pickle', 'Peanut', 'Pumpkin', 'Apple', 'Peach', 'Pineapple', 'Strawberry', 'Blueberry', 'Grape'];

    return '${funnyFirstNames.random()} ${funnyLastNames.random()}';
  }
}
