import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:DoctorApp/repository/LoginRepository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository repository;

  // ignore: invalid_required_positional_param
  LoginBloc(@required this.repository) : super(null);

  @override
  // ignore: override_on_non_overriding_member
  // Cho phét truy cập bên ngoài LoginInitialState
  LoginState get initialState => LoginInitialState();

  @override
  // mapEventToState: nhận event làm tham số return về state mới
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // yield: nó như return
    // Nếu event là ButtonLoginClickEvent
    if (event is ButtonLoginClickEvent) {
      yield LoginLoadingState();
      try {
        // dữ liệu trả về sau khi login
        Response response = await repository.requestLogin(
            event.context, event.phoneNumber, event.password);

        // return đối tượng LoginLoadedState nhận vào response
        yield LoginLoadedState(responseLoginData: response);
//        yield LoginInitialState();
      } catch (e) {
        // return LoginError nhận vào message error
        yield LoginErrorState(message: e.toString());
      }
    } else if (event is LoginInitialEvent) {
      // Nếu là sự kiện khởi tạo của login thì return LoginInitialState
      yield LoginInitialState();
    }
  }
}

@immutable // để chú thích lớp bất biến => tất cả những đối tượng hay biến
// của đối tượng kế thừa đều phải định nghĩa final
abstract class LoginEvent {}

class ButtonLoginClickEvent extends LoginEvent {
  final phoneNumber, password, context;

  ButtonLoginClickEvent(this.phoneNumber, this.password, this.context);
}

class LoginInitialEvent extends LoginEvent {
  final context;

  LoginInitialEvent(this.context);
}

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

// ignore: must_be_immutable
class LoginLoadedState extends LoginState {
  Response responseLoginData;

  LoginLoadedState({@required this.responseLoginData});
}

// ignore: must_be_immutable
class LoginErrorState extends LoginState {
  String message;

  LoginErrorState({@required this.message});
}
