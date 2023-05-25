import 'package:flutter_test/flutter_test.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';
import 'package:med_tech_mobile/repositories/local_data_base/models/user_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('LocalDBRepository', () {
    late LocalDBRepository localDBRepository;

    setUp(() {
      localDBRepository = LocalDBRepository();
    });

    test('Сохранение и чтение данных пользователя', () async {
      final username = 'admin';
      final password = 'password';
      final token = 'token';

      await localDBRepository.updateUserData(username, password, token);
      final userData = await localDBRepository.readUsernamePassword();

      expect(userData, equals([username, password]));
    });

    test('Удаление данных пользователя', () async {
      final username = 'admin';
      final password = 'password';
      final token = 'token';

      await localDBRepository.updateUserData(username, password, token);
      await localDBRepository.deleteUserData();
      final userData = await localDBRepository.readUsernamePassword();

      expect(userData, equals([null, null]));
    });

    test('Добавление и удаление данных контроллера', () async {
      final jsonData = '{"data": "controller data"}';

      localDBRepository.addControllerData(jsonData);
      final dataSize = await localDBRepository.getControllerDataSize();
      final deletedData = await localDBRepository.getControllerDataSizeAndDelete();

      expect(dataSize, equals(1));
      expect(deletedData.length, equals(1));
      expect(deletedData[0]?.dataJSON, equals(jsonData));
    });
  });
}
