import 'package:dhomeotic/presentation/app/bloc/app_bloc.dart';
import 'package:dhomeotic/presentation/app/bloc/auth_bloc.dart';
import 'package:dhomeotic/presentation/app/bloc/user_bloc.dart';
import 'package:dhomeotic/presentation/feature/home/widget/ui/device_detail/device_detail_screen.dart';
import 'package:dhomeotic/presentation/feature/home/widget/widgets.dart';
import 'package:dhomeotic/services/ble/ble_device_interactor.dart';
import 'package:dhomeotic/services/ble/ble_logger.dart';
import 'package:dhomeotic/services/ble/ble_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<BleScanner, BleScannerState?, BleLogger>(
        builder: (_, bleScanner, bleScannerState, bleLogger, __) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            children: [
              BlocBuilder<UserBloc, UserState>(
                buildWhen: (previous, current) =>
                    previous.discoveredDevice != current.discoveredDevice,
                builder: (context, state) {
                  return Expanded(
                    child: ListView(
                      children: [
                        ...bleScannerState!.discoveredDevices.map((device) {
                          if (device == state.discoveredDevice) {
                            return ListTile(
                              title: Text(device.name),
                              subtitle:
                                  Text("${device.id}\nRSSI: ${device.rssi}"),
                              leading: const BluetoothIcon(),
                              onTap: () async {
                                await Navigator.push<void>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DeviceDetailScreen(
                                            device: device)));
                              },
                            );
                          } else {
                            return const SizedBox();
                          }
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Consumer<BleDeviceInteractor>(
                        builder: (context, interactor, _) {
                      return ListView.builder(
                          itemCount: (state.discoveredServices != null &&
                                  state.discoveredServices!.isNotEmpty)
                              ? state.discoveredServices!.first.characteristics
                                  .length
                              : 0,
                          itemBuilder: (context, index) {
                            final characteristic = state.discoveredServices!
                                .first.characteristics[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    interactor.writeCharacterisiticWithResponse(
                                        QualifiedCharacteristic(
                                            characteristicId:
                                                characteristic.characteristicId,
                                            serviceId: characteristic.serviceId,
                                            deviceId:
                                                state.discoveredDevice!.id),
                                        [index]);
                                  },
                                  child: Center(
                                    child: Text(
                                        "${state.discoveredServices!.first.characteristics[index].characteristicId}"),
                                  )),
                            );
                          });
                    });
                  },
                ),
              )
            ],
          ));
    });
  }
}
