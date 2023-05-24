import 'package:isar/isar.dart';
part 'user_data.g.dart';
///launch command in terminal before app running:
///flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

@collection
class UserData {
  UserData({required this.username, required this.password, required this.token});
  Id id = 1;

  late String? username;

  late String? password;

  late String? token;
}