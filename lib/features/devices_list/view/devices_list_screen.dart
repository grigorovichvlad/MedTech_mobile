import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:med_tech_mobile/features/devices_list/widgets/device_tile.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:med_tech_mobile/features/devices_list/bloc/devices_list_bloc.dart';
import 'package:med_tech_mobile/features/devices_list/widgets/widgets.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import '../../../repositories/local_data_base/local_db_repository.dart';
import '../../widgets/exit_button.dart';

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
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Доступные устройства',
          style: textTheme.headlineLarge,
        ),
        actions: [
          const ExitButton().build(context),
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: theme.indicatorColor,
        color: Colors.white,
        onRefresh: () async {
          _bluetoothDevicesList.add(LoadDevicesList());
          await Future.delayed(const Duration(seconds: 4));
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: BlocBuilder<DevicesListBloc, DevicesListState>(
          bloc: _bluetoothDevicesList,
          builder: (context, state) {
            if (state is DevicesListLoaded) {
              debugPrint(state.devicesList.length.toString());
              return ListView.separated(
                  itemCount: state.devicesList.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final device = state.devicesList[i];
                    return DeviceTile(
                      device: device,
                      onTap: () {
                        debugPrint('Подключение к ${device.name}');
                        _bluetoothDevicesList.add(ConnectDevice(
                            id: device.id,
                            onSubmit: () async {
                              var isNeedRefresh =
                                  await Navigator.pushReplacementNamed(
                                      context, '/status');
                              if (isNeedRefresh == true ||
                                  isNeedRefresh == null) {
                                _bluetoothDevicesList.add(LoadDevicesList());
                              }
                            }));
                      },
                    );
                  });
            }

            if (state is DevicesListLoadingFailure) {
              var bleException = state.exception;
              bleException = bleException.substring(
                  bleException.indexOf("message: \"") + 10,
                  bleException.toString().lastIndexOf("\""));
              var exceptionCode = bleException.substring(
                  bleException.indexOf("(code ") + 6,
                  bleException.toString().indexOf(")"));

              switch (exceptionCode) {
                //Тут обработаем любую ошибку блютуза.
                case '1': //BLE powerOff
                  bleException = 'Включите Bluetooth';
                  break;
                case '3': //Location permissions missing
                  bleException =
                      'Необходимо разрешение\n\"Устройства поблизости\"';
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bleException,
                          style: textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        FilledButton.tonal(
                          onPressed: () async {
                            while (await openAppSettings() ==
                                false) {} //точно откроет настройки
                            _bluetoothDevicesList.add(LoadDevicesList());
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0)),
                          child: Text("Открыть настройки",
                              style: textTheme.titleSmall),
                        ),
                      ],
                    ),
                  );
                  break;
                case '2147483646': //Throttle
                  bleException = 'Слишком быстро.\nПовторите позже.';
                  break;
                default:
                  break;
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bleException,
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    FilledButton.tonal(
                      onPressed: () {
                        _bluetoothDevicesList.add(LoadDevicesList());
                      },
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0)),
                      child: Text("Обновить", style: textTheme.titleSmall),
                    ),
                  ],
                ),
              );
            }
            if (state is DeviceConnecting) {}

            return Center(
                child: CircularProgressIndicator(color: theme.indicatorColor));
          },
        ),
      ),
    );
  }
}
