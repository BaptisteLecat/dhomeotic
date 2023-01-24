import 'package:dhomeotic/presentation/feature/home/widget/ui/ble_status_screen.dart';
import 'package:dhomeotic/presentation/feature/home/widget/ui/device_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BleStatus?>(
      builder: (_, status, __) {
        if (status == BleStatus.ready) {
          return const DeviceListScreen();
        } else {
          return BleStatusScreen(status: status ?? BleStatus.unknown);
        }
      },
    );
  }
}