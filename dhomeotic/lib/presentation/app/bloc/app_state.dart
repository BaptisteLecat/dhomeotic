part of 'app_bloc.dart';

enum AppStatus {
  initial,
  success,
  failure,
  inProgress,
  splashScreen,
  login,
  logout,
  selectBluetoothDevice,
}

extension AppStatusX on AppStatus {
  bool get initial => this == AppStatus.initial;
  bool get success => this == AppStatus.success;
  bool get failure => this == AppStatus.failure;
  bool get inProgress => this == AppStatus.inProgress;
  bool get splashScreen => this == AppStatus.splashScreen;
  bool get login => this == AppStatus.login;
  bool get logout => this == AppStatus.logout;
  bool get selectBluetoothDevice => this == AppStatus.selectBluetoothDevice;
}

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.initial,
    this.message = '',
    this.authUser,
    this.discoveredDevice,
  });

  final AppStatus status;
  final String message;
  final User? authUser;
  final DiscoveredDevice? discoveredDevice;

  @override
  List<Object?> get props => [
        status,
        message,
        authUser,
        discoveredDevice,
      ];

  AppState copyWith({
    AppStatus? status,
    String? message,
    User? authUser,
    DiscoveredDevice? discoveredDevice,
  }) {
    return AppState(
      status: status ?? this.status,
      message: message ?? this.message,
      authUser: authUser,
      discoveredDevice: discoveredDevice,
    );
  }
}
