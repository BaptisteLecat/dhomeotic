import 'package:dhomeotic/presentation/app/app_route.dart';
import 'package:dhomeotic/presentation/app/bloc/app_bloc.dart';
import 'package:dhomeotic/presentation/app/bloc/auth_bloc.dart';
import 'package:dhomeotic/presentation/app/bloc/user_bloc.dart';
import 'package:dhomeotic/services/ble/ble_device_connector.dart';
import 'package:dhomeotic/services/ble/ble_device_interactor.dart';
import 'package:dhomeotic/services/ble/ble_logger.dart';
import 'package:dhomeotic/services/ble/ble_scanner.dart';
import 'package:dhomeotic/services/ble/ble_status_monitor.dart';
import 'package:dhomeotic/theme/dark_theme.dart';
import 'package:dhomeotic/theme/light_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late AuthBloc _authBloc;
  late AppBloc _appBloc;
  late UserBloc _userBloc;
  GoRouter? _router;
  AppStatus? oldAppStatus;
  final _ble = FlutterReactiveBle();
  late BleLogger _bleLogger;
  late BleScanner _scanner;
  late BleStatusMonitor _monitor;
  late BleDeviceConnector _connector;
  late BleDeviceInteractor _serviceDiscoverer;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc();
    _userBloc = UserBloc();
    _appBloc = AppBloc(authBloc: _authBloc)..add(UserLogInState());

    _bleLogger = BleLogger(ble: _ble);
    _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
    _monitor = BleStatusMonitor(_ble);
    _connector = BleDeviceConnector(
      ble: _ble,
      logMessage: _bleLogger.addToLog,
    );
    _serviceDiscoverer = BleDeviceInteractor(
      bleDiscoverServices: _ble.discoverServices,
      readCharacteristic: _ble.readCharacteristic,
      writeWithResponse: _ble.writeCharacteristicWithResponse,
      writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
      subscribeToCharacteristic: _ble.subscribeToCharacteristic,
      logMessage: _bleLogger.addToLog,
    );

    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _router = _goRouter(_appBloc);
  }

  GoRouter _goRouter(AppBloc appBloc) {
    return GoRouter(
        refreshListenable: GoRouterRefreshStream(appBloc.stream),
        initialLocation: AppRoute.onbording.path,
        routes: AppRoute.getRoutes(),
        errorBuilder: (context, state) {
          return const Center(
            child: Text("404"),
          );
        },
        redirect: (state) {
          if (appBloc.state.status != oldAppStatus) {
            oldAppStatus = appBloc.state.status;

            final goingFromLogin = state.subloc == AppRoute.login.path;
            final goingFromRegister = state.subloc == AppRoute.signup.path;
            final goingFromHome = state.subloc == AppRoute.home.path;
            final goingFromSplashScreen =
                state.subloc == AppRoute.onbording.path;

            switch (appBloc.state.status) {
              case AppStatus.logout:
                if (!goingFromLogin) {
                  return state.namedLocation(AppRoute.login.name);
                } else if (!goingFromRegister) {
                  return state.namedLocation(AppRoute.signup.name);
                } else {
                  return state.namedLocation(AppRoute.login.name);
                }
              case AppStatus.login:
                if ((!goingFromHome && !goingFromRegister) || goingFromLogin) {
                  _userBloc.add(
                      UserFetchOne(id: appBloc.state.authUser!.uid ?? "0"));
                  return state.namedLocation(AppRoute.home.name,
                      params: {"index": "0"});
                } else {
                  return null;
                }

              default:
                return (!goingFromSplashScreen)
                    ? state.namedLocation(AppRoute.onbording.name)
                    : null;
            }
          } else {
            return null;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: _authBloc,
        ),
        BlocProvider.value(
          value: _appBloc,
        ),
        BlocProvider.value(
          value: _userBloc,
        ),
      ],
      child: MultiProvider(
        providers: [
          Provider.value(value: _scanner),
          Provider.value(value: _monitor),
          Provider.value(value: _connector),
          Provider.value(value: _serviceDiscoverer),
          Provider.value(value: _bleLogger),
          StreamProvider<BleScannerState?>(
            create: (_) => _scanner.state,
            initialData: const BleScannerState(
              discoveredDevices: [],
              scanIsInProgress: false,
            ),
          ),
          StreamProvider<BleStatus?>(
            create: (_) => _monitor.state,
            initialData: BleStatus.unknown,
          ),
          StreamProvider<ConnectionStateUpdate>(
            create: (_) => _connector.state,
            initialData: const ConnectionStateUpdate(
              deviceId: 'Unknown device',
              connectionState: DeviceConnectionState.disconnected,
              failure: null,
            ),
          ),
        ],
        child: MaterialApp.router(
          routeInformationProvider: _router!.routeInformationProvider,
          routeInformationParser: _router!.routeInformationParser,
          routerDelegate: _router!.routerDelegate,
          title: "Dhomeotic App",
          debugShowCheckedModeBanner: false,
          theme: lightTheme(context),
          darkTheme: darkTheme(context),
        ),
      ),
    );
  }
}
