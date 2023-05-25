import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:med_tech_mobile/features/login/bloc/login_page_bloc.dart';
import 'package:med_tech_mobile/features/login/login.dart';
import 'package:bloc_test/bloc_test.dart';

class MockDio extends Mock implements Dio {}

void main() {

  group('LoginPageBloc', () {
    late LoginPageBloc bloc;
    late MockDio mockDio;

    setUp(() {
      // Создание экземпляра мока для класса Dio
      mockDio = MockDio();
      bloc = LoginPageBloc();
    });

    test('Логин должны получить токен', () async {
      // Arrange
      final username = 'admin';
      final password = 'admin';
      final token = 'admin';

      final response = await Dio().post(
        'http://127.0.0.1:8000/api/token/',
        data: {'email': username, 'password': password},
      );


      when(mockDio.post('null', data: anyNamed('data')))
          .thenAnswer((_) async => response);

      // Act
      final result = await bloc.loginUser(username, password);

      // Assert
      expect(result, equals(token));
      verify(mockDio.post('null', data: {'email': username, 'password': password}));
    });



    test('Логин и не получаем токен', () async {
      const username = 'admin';
      const password = 'admin';

      final errorResponse = Response(statusCode: 400, requestOptions: RequestOptions(path: ''));
      when(mockDio.post('null', data: anyNamed('data'))).thenThrow((_) async => errorResponse);

      final result = await bloc.loginUser(username, password);

      expect(result, isNull);
    });

    test('Неверные данные для входа',
            () async {
          const username = 'User';
          const password = 'Pass';

          final result = await bloc.loginUser(username, password);

          expect(result, isNull);
        });
  });
}

