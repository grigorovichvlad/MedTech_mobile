import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_tech_mobile/features/devices_list/widgets/device_tile.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:med_tech_mobile/features/devices_list/bloc/devices_list_bloc.dart';
import 'package:med_tech_mobile/features/devices_list/widgets/widgets.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

class BluetoothDevices extends StatefulWidget {
  const BluetoothDevices({Key? key}) : super(key: key);

  @override
  State<BluetoothDevices> createState() => _BluetoothDevicesState();
}

class _BluetoothDevicesState extends State<BluetoothDevices> {

  final _bluetoothDevicesList = DevicesListBloc(GetIt.I<BluetoothDeviceRepository>());

  @override
  void initState() {
    _bluetoothDevicesList.add(LoadDevicesList());
    super.initState();
  }

  // List<Widget> txt = [];
  //
  // void fun(TextStyle? textStyle) {
  //   for (int i = 0; i < 2; i++) {
  //     txt.add(
  //       bluetoothCardTemplate(textStyle),
  //     );
  //     txt.add(Divider(height: 10));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
//    fun(textTheme.labelSmall);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Доступные устройства',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body:  BlocBuilder<DevicesListBloc, DevicesListState>(
        bloc: _bluetoothDevicesList,
        builder: (context, state) {
          if (state is DevicesListLoaded){
            return ListView.separated(
              padding: EdgeInsets.only(top: 16),
              itemCount: state.devices_list.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, i){
                final device = state.devices_list[i];
                return DeviceTile(device: device);
              }
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
