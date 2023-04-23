import 'package:isar/isar.dart';
part 'user_data.g.dart';
///launch command in terminal before app running:
///flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

@collection
class UserData {
  UserData({this.username, this.password, this.bluetoothId});
  Id id = 1;

  late String? username;

  late String? password;

  late String? bluetoothId;
}
