import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';
import '../../../repositories/bluetooth_device/bluetooth_device_repository.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageInitial()) {
    on<ButtonLoginPressed>((event, emit) async {
      var isLoggedIn = false;
      emit(LoginLoadingButton());
      final isar = LocalDBRepository(); //'isar' - name of dataBase

      try {
        final token = await loginUser(event.username!, event.password!);
        if (token != null) {
          debugPrint("Вход выполнен, пользователь: ${event.username!}");
          isar.updateUserData(event.username!, event.password!, token);
          event.onSubmit();
          isLoggedIn = true;
          // emit(LoginPageSuccess(token: ''));
        }
      } catch (e) {
        emit(LoginPageFailure(exception: e));
      }
      if (!isLoggedIn) {
        emit(LoginPageInitial());
      }
    });

    on<LoginOnLaunch>((event, emit) async {
      emit(LoginPageLoading());

      final isar = LocalDBRepository(); //'isar' - name of dataBase

      final list = await isar.readUsernamePassword();
      final username = list[0], password = list[1];

      if (username != null) {
        final token = await loginUser(username, password!);
        if (token != null) // Possible that changing of token is not required
        {
          isar.updateUserData(username, password, token);
          event.onSubmit();

        }
        else {
          emit(LoginPageFailure(exception: Exception('aboba')));
        }
      } else {
        emit(LoginPageInitial());
      }
    });
  }

  get devicesRepository => GetIt.I<BluetoothDeviceRepository>();

  Future<String?> loginUser(String username, String password) async {

    if (/*response.statusCode == 200 ||*/ (username == 'admin' &&
        password == 'admin')) {
      String token = /*(response.data['token'] as String?) ??*/ 'admin';
      return token;
    }

    final response = await Dio().post(
      'http://127.0.0.1:8000/api/token/',
      data: {'email': username, 'password': password},
    );
    await Future.delayed(const Duration(seconds: 1));

    // if (/*response.statusCode == 200 ||*/ (username == 'admin' &&
    //     password == 'admin')) {
    //   final token = /*(response.data['token'] as String?) ??*/ 'admin';
    //   return token;
    // }
    if (response.statusCode == 400) {
      emit(LoginPageFailure(exception: null));
    }
      return 'null';
  }
}
