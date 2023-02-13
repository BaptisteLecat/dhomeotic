import 'package:dhomeotic/presentation/app/bloc/app_bloc.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back, ${context.read<AppBloc>().state.authUser!.firstname}",
                  ),
                  Text(
                    "Nothing as changed since last time",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Room $index",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            //Grid of all the devices in the selected room.
            //This grid display 2 devices per row.
            //The devices are displayed inside card with a bigger height than the width. Their border radius is 16.
            //The card content display an icon, the device name, number of device of this type and a switch to turn the device on or off.
            Expanded(
              flex: 3,
              child: SizedBox(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                      child: Icon(Icons.light,
                                          color: Colors.white))),
                              const SizedBox(height: 16),
                              Text(
                                "Lamp",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "2 devices",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
