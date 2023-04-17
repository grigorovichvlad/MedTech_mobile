import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageInitial()) {
    on<Login>((event, emit) {
      event.onSubmit();
      // try {
      //   if (state is! LoginPageLoginRight) {
      //     emit(LoginPageLoading());
      //   }
      //   emit(LoginPageLoginRight());
      // }catch(e) {
      //   emit(LoginPageLoginFailure(exception: e));
      // }
    });
  }
}
