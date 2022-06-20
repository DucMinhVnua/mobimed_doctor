import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import 'package:DoctorApp/repository/UserInfoRepository.dart';
import 'package:flutter/material.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoRepository repository;

  // ignore: invalid_required_positional_param
  UserInfoBloc(@required this.repository) : super(null);

  @override
  // ignore: override_on_non_overriding_member
  UserInfoState get initialState => UserInfoInitialState();

  @override
  Stream<UserInfoState> mapEventToState(UserInfoEvent event) async* {
    if (event is LoadUserInfoEvent) {
      yield UserInfoLoadingState();
      try {
        QueryResult response = await repository.requestUserInfo(event.context);
//        requestRegisterDevice
        yield UserInfoLoadedState(responseUserInfoData: response);
      } catch (e) {
        yield UserInfoErrorState(message: e.toString());
      }
    }
  }
}

@immutable
abstract class UserInfoEvent {}

class LoadUserInfoEvent extends UserInfoEvent {
  final context;

  LoadUserInfoEvent(this.context);
}

@immutable
abstract class UserInfoState {}

class UserInfoInitialState extends UserInfoState {}

class UserInfoLoadingState extends UserInfoState {}

// ignore: must_be_immutable
class UserInfoLoadedState extends UserInfoState {
  QueryResult responseUserInfoData;

  UserInfoLoadedState({@required this.responseUserInfoData});
}

// ignore: must_be_immutable
class UserInfoErrorState extends UserInfoState {
  String message;

  UserInfoErrorState({@required this.message});
}
