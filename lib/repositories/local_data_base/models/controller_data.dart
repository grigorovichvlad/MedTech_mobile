import 'package:isar/isar.dart';
part 'controller_data.g.dart';
///launch command in terminal before app running:
///flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs

@collection
class ControllerData {
  ControllerData({required this.dataJSON});

  Id id = Isar.autoIncrement;

  final String dataJSON;
}
