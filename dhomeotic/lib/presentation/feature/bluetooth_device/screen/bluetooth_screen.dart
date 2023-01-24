import 'package:dhomeotic/presentation/feature/bluetooth_device/view/bluetooth_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BluetoothScreen extends StatelessWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Appareils Bluetooth")),
        body: const SafeArea(child: BluetoothView()));
  }
}
