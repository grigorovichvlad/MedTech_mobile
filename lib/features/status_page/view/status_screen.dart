import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/features/status_page/bloc/status_screen_bloc.dart';
import 'package:med_tech_mobile/features/widgets/confirmation_dialog.dart';
import 'package:med_tech_mobile/features/widgets/exit_button.dart';
import 'dart:math';
import '../../../repositories/bluetooth_device/bluetooth_device_repository.dart';
import '../../../repositories/local_data_base/local_db_repository.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key, required this.name, required this.adress})
      : super(key: key);
  final String name, adress;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final devicesRepository = GetIt.I<BluetoothDeviceRepository>();
  final _statusBloc = StatusBloc(GetIt.I<BluetoothDeviceRepository>());
  final isar = LocalDBRepository();
  Map<int, String> unitsOfData = {
    0: "Б",
    1: "КБ",
    2: "МБ",
    3: "ГБ",
  };

  @override
  void initState() {
    _statusBloc.add(LoadStatusScreen(onDisconnect: () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              content: const Text('Устройство\nбыло отключено',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center),
              actions: <Widget>[
                FilledButton(
                  style: IconButton.styleFrom(
                    highlightColor: Colors.blue[400],
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(
                        true); // dismisses only the dialog and returns false
                    Navigator.pushReplacementNamed(context, '/devices');
                    devicesRepository.disconnect();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Ок', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final name = widget.name;
    final adress = widget.adress;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ConfirmationDialog(
                    onAgree: () async {
                      Navigator.pushReplacementNamed(context, '/devices');
                      devicesRepository
                          .disconnect(); //Отключение устройства, если оно подключено
                    },
                    query: 'Вы точно хотите сменить устройство?')
                .build(context);
          },
          padding: const EdgeInsets.all(16.0),
          highlightColor: Colors.blue[400],
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
          icon: const Icon(Icons.devices, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Состояние',
          style: textTheme.headlineLarge,
        ),
        actions: [
          const ExitButton().build(context),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<StatusBloc, StatusState>(
          bloc: _statusBloc,
          builder: (context, state) {
            if (state is StatusScreenLoaded) {
              num dataSize = state.dataSize;
              int countUnit = 0;
              while (dataSize > 1024 && countUnit < 3) {
                dataSize /= 1024;
                countUnit++;
              }
              String dataSizeStr = dataSize.toStringAsPrecision(
                  (log(dataSize == 0 ? 1 : dataSize) / log(10)).floor() + 2) +
                  unitsOfData[countUnit]!;
              return Column(
                children: [
                  Container(
                    height: 120,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.grey[200]),
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Устройство',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Имя: $name'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('MAC-адрес: $adress'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.grey[200]),
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Column(
                      children: <Widget>[
                        const Text('Сеть',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Подключение к серверу: '),
                            Icon(
                                (state.internetConnection
                                    ? Icons.check_rounded
                                    : Icons.close_rounded),
                                color: (state.internetConnection
                                    ? Colors.green
                                    : Colors.red)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Количество запросов: ${state.count}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.grey[200]),
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Column(
                      children: <Widget>[
                        const Text('Хранилище',
                            style: TextStyle(fontWeight: FontWeight.w300)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Заполнено: $dataSizeStr'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          },
        ),
      ),
    );
  }
}
