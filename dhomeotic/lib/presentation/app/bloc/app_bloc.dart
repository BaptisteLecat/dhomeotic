import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dhomeotic/common/error/app_exception.dart';
import 'package:dhomeotic/domain/entity/entity.dart';
import 'package:dhomeotic/domain/repository/auth_repository/auth_repository.dart';
import 'package:dhomeotic/presentation/app/bloc/auth_bloc.dart';
import 'package:dhomeotic/services/auth/auth_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AuthBloc authBloc;
  final AuthService authService = AuthService();
  bool startListeningAuthChange = false;
  AppBloc({required this.authBloc}) : super(const AppState()) {
    authBloc.stream.listen((authState) {
      switch (authState.runtimeType) {
        case Authenticated:
          _firebaseCheckAuthState();
          startListeningAuthChange = true;
          break;
        default:
      }
    });

    AuthService.firebaseAuthInstance
        .authStateChanges()
        .listen((firebase.User? firebaseUser) async {
      ///This Stream is not used until the authentication process isn't completed.
      log("startListeningAuthChange = $startListeningAuthChange");
      if (startListeningAuthChange) {
        if (firebaseUser != null) {
          print('User is signed in on mobile!');
          try {
            await AuthRepository()
                .whoAmI(firebaseUser: firebaseUser)
                .then((user) {
              log(user.toString());
              emit(state.copyWith(
                status: AppStatus.login,
                message: '',
                authUser: user.copyWith(firebaseUser: firebaseUser),
              ));
            }).onError((AppException error, stackTrace) async {
              if (error.statusCode == 401) {
                AuthService.firebaseAuthInstance.signOut();
              }
            });
          } catch (e) {
            emit(state.copyWith(
              status: AppStatus.logout,
              message: '',
              authUser: null,
            ));
          }
        } else {
          print('User is currently signed out!');
          emit(state.copyWith(
            status: AppStatus.logout,
            message: '',
            authUser: null,
          ));
        }
      }
    });

    on<UserLogInState>((event, emit) async {
      _firebaseCheckAuthState();
    });

    on<SelectBluetoothDevice>((event, emit) async {
      emit(state.copyWith(
        discoveredDevice: event.discoveredDevice,
      ));
    });
  }

  _firebaseCheckAuthState() async {
    try {
      if (AuthService.firebaseAuthInstance.currentUser != null) {
        print('On start the user is signed in');
        //await AuthService.firebaseAuthInstance.signOut();
        await AuthRepository()
            .whoAmI(firebaseUser: AuthService.firebaseAuthInstance.currentUser!)
            .then((user) {
          startListeningAuthChange = true;
          log(user.toString());
          emit(state.copyWith(
            status: AppStatus.login,
            message: '',
            authUser: user.copyWith(
                firebaseUser: AuthService.firebaseAuthInstance.currentUser!),
          ));
        }).onError((AppException error, stackTrace) async {
          if (error.statusCode == 401) {
            AuthService.firebaseAuthInstance.signOut();
            emit(state.copyWith(
              status: AppStatus.logout,
              message: '',
              authUser: null,
            ));
          }
        });
      } else {
        print('On start the user is not signed in');
        emit(state.copyWith(
          status: AppStatus.logout,
          message: '',
          authUser: null,
        ));
      }
    } catch (e) {
      print('An error occurred while checking the user sign in status');
      emit(state.copyWith(
        status: AppStatus.logout,
        message: '',
        authUser: null,
      ));
    }
  }
}
