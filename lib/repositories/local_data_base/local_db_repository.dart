import 'package:isar/isar.dart';
import 'package:med_tech_mobile/repositories/local_data_base/models/controller_data.dart';
import 'package:med_tech_mobile/repositories/local_data_base/models/user_data.dart';
import 'package:path_provider/path_provider.dart';

class LocalDBRepository {
  late Future<Isar> db;

  LocalDBRepository() {
    db = _openDB();
  }

  Future<Isar> _openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([UserDataSchema, ControllerDataSchema],
          directory: dir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> updateUserData(String username, String password) async {
    final isar = await db;
    final data = UserData(username: username, password: password);
    isar.writeTxnSync<int>(() => isar.userDatas.putSync(data));
  }

  Future<void> deleteUserData() async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.userDatas.deleteSync(1));
    deleteControllerData();
    //TODO: Delete the token
  }

  Future<void> deleteControllerData() async {
    final isar = await db;
    isar.writeTxnSync<void>(() => isar.controllerDatas.clearSync());
  }

  Future<List<String?>> readUsernamePassword() async {
    final isar = await db;
    final userData = await isar.userDatas.get(1);
    return [userData?.username, userData?.password];
  }

  void addControllerData(String json) async {
    final isar = await db;
    final data = ControllerData(dataJSON: json);
    isar.writeTxnSync<void>(() => isar.controllerDatas.putSync(data));

  }
}
