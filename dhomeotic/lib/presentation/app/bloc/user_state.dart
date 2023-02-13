part of 'user_bloc.dart';

enum UserStatus {
  initial,
  success,
  failure,
  inProgress,
  select,
  creation,
  cancelCreation,
  confirmCreation,
  created,
  deleted,
  updated,
  resetPassword,
  emailNotFound,
  passwordReseted,
  selectBluetoothDevice,
}

extension UserStatusX on UserStatus {
  bool get initial => this == UserStatus.initial;
  bool get success => this == UserStatus.success;
  bool get failure => this == UserStatus.failure;
  bool get inProgress => this == UserStatus.inProgress;
  bool get select => this == UserStatus.select;
  bool get creation => this == UserStatus.creation;
  bool get cancelCreation => this == UserStatus.cancelCreation;
  bool get confirmCreation => this == UserStatus.confirmCreation;
  bool get created => this == UserStatus.created;
  bool get deleted => this == UserStatus.deleted;
  bool get updated => this == UserStatus.updated;
  bool get resetPassword => this == UserStatus.resetPassword;
  bool get emailNotFound => this != UserStatus.emailNotFound;
  bool get passwordReseted => this == UserStatus.passwordReseted;
  bool get selectBluetoothDevice => this == UserStatus.selectBluetoothDevice;
}

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.initial,
    this.message = '',
    List<User>? users,
    User? user,
    this.discoveredDevice,
    this.discoveredServices = const [],
    this.deviceId,
  })  : users = users ?? const [],
        user = user ?? User.empty;

  final UserStatus status;
  final String message;
  final List<User> users;
  final User user;
  final DiscoveredDevice? discoveredDevice;
  final List<DiscoveredService>? discoveredServices;
  final String? deviceId;

  @override
  List<Object?> get props => [
        status,
        message,
        users,
        user,
        discoveredDevice,
        discoveredServices,
        deviceId,
      ];

  UserState copyWith({
    UserStatus? status,
    String? message,
    List<User>? users,
    User? user,
    DiscoveredDevice? discoveredDevice,
    List<DiscoveredService>? discoveredServices,
    String? deviceId,
  }) {
    return UserState(
      status: status ?? this.status,
      message: message ?? this.message,
      users: users ?? this.users,
      user: user ?? this.user,
      discoveredDevice: discoveredDevice ?? this.discoveredDevice,
      discoveredServices: discoveredServices ?? this.discoveredServices,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
