import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';
import 'package:dio/dio.dart';


part 'login_page_event.dart';

part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageInitial()) {
    on<ButtonLoginPressed>((event, emit) async {
      emit(LoginPageLoading());

      final isar = LocalDBRepository(); //'isar' - name of dataBase

      try {
        final result = await loginUser(event.username!, event.password!);
        if (result) {
          debugPrint("Вход выполнен, пользователь: " + event.username!);
          isar.updateUserData(event.username!, event.password!);
          event.onSubmit();
          emit(LoginPageSuccess());
        }
      } catch (e) {
        emit(LoginPageFailure(exception: e));
      }

      emit(LoginPageInitial());
    });

    on<LoginOnLaunch>((event, emit) async {
      emit(LoginPageLoading());

      final isar = LocalDBRepository(); //'isar' - name of dataBase

      final list = await isar.readUsernamePassword();
      final username = list[0], password = list[1];

      if (username != null) {
        isar.updateUserData(username, password!);
        event.onSubmit();
      } else {
        emit(LoginPageInitial());
      }
    });
  }

  Future<bool> loginUser(String username, String password) async {
    // final response = await Dio().post(
    //   'https://endpoint.com/login',
    //   data: {'username': username, 'password': password},
    // );

    if ((username == "admin") && (password == "admin")) {
      return true;
    }
    else
      return false;
    // else {
    //   return response.statusCode == 200;
    // }
  }
}

