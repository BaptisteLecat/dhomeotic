import 'package:dhomeotic/presentation/app/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Home"),
          const SizedBox(height: 20),
          Text("Devices:"),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogOutRequested());
              },
              child: Text("Logout"))
        ],
      ),
    );
  }
}
