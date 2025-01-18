import 'package:app/core/extensions.dart';

class UserRepo {
  UserRepo._();
  static UserRepo get instance => UserRepo._();

  String randomName() {
    final titles = ['Mr.', 'Mrs.', 'Ms.', 'Miss', 'Dr.'];
    final middles = ['Perky', 'Wunderpus', 'Mc', 'Pleasing', 'Pink', 'Tasseled', 'Red-lipped'];
    final lastNames = ['Unicorn', 'Lumpsucker', 'Fizz', 'Armadillo', 'Baboon'];

    return '${titles.random()} ${middles.random()} ${lastNames.random()}';
  }
}
