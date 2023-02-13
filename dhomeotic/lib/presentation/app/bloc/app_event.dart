part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent([List props = const []]);

  @override
  List<Object> get props => [];
}

class UserLogInState extends AppEvent {}

class SelectBluetoothDevice extends AppEvent {
  final DiscoveredDevice discoveredDevice;

  const SelectBluetoothDevice({required this.discoveredDevice});
}
