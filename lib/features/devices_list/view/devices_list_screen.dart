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
  final _bluetoothDevicesList =
      DevicesListBloc(GetIt.I<BluetoothDeviceRepository>());

  @override
  void initState() {
    _bluetoothDevicesList.add(LoadDevicesList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Доступные устройства',
          style: textTheme.headlineLarge,
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: theme.indicatorColor,
        color: Colors.white,
        onRefresh: () async {
          _bluetoothDevicesList.add(LoadDevicesList());
        },
        child: BlocBuilder<DevicesListBloc, DevicesListState>(
          bloc: _bluetoothDevicesList,
          builder: (context, state) {
            if (state is DevicesListLoaded) {
              return ListView.separated(
                  itemCount: state.devicesList.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final device = state.devicesList[i];
                    return DeviceTile(device: device, onTap: () {
                      debugPrint('Подключение к ${device.name}');
                      if (device.id != null) {
                        _bluetoothDevicesList.add(ConnectDevice(id: device.id));
                      } else {
                        debugPrint('Device ID is null');
                      }

                    },
                    );
                  });
            }
            if (state is DevicesListLoadingFailure) {
              //Тут обработаем ошибку, то что блютус отключен.
              return Center(
                  child:
                      Text('Включите Bluetooth', style: textTheme.bodySmall));
            }
            return Center(child: CircularProgressIndicator(color: theme.indicatorColor));
          },
        ),
      ),
    );
  }
}
