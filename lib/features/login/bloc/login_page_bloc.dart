import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';

part 'login_page_event.dart';

part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageInitial()) {
    on<ButtonLoginPressed>((event, emit) async {
      emit(LoginButtonLoading());

      final isar = LocalDBRepository(); //'isar' - name of dataBase

      //TODO: API query
      // if (endpoinAuth(username, password)) {
      //
      // }

      if (event.username != null) {
        // temporary statement
        isar.updateUserData(event.username!, event.password!);
        event.onSubmit();
        emit(LoginPageLoginRight());
      }
      emit(LoginPageInitial());
    });

    on<LoginOnLaunch>((event, emit) async {
      emit(LoginPageLoading());

      final isar = LocalDBRepository(); //'isar' - name of dataBase

      final list = await isar.readUsernamePassword();
      final username = list[0], password = list[1];

      //TODO: API query
      // if (endpoinAuth(username, password)) {
      //
      // }

      if (username != null) {
        isar.updateUserData(username, password!);
        event.onSubmit();
      } else {
        emit(LoginPageInitial());
      }
    });
  }
}
