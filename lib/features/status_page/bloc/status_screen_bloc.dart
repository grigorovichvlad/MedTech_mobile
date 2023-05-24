import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/repositories/DB_isolate_repository/db_isolate_repository.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';

part 'status_screen_event.dart';

part 'status_screen_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final _dbInstance = GetIt.I<DBIsolateRepository>();
  final isar = LocalDBRepository();
  int counter = 0;
  bool internetConnection = false;

  StatusBloc(this.devicesRepository) : super(StatusScreenInitial()) {
    on<LoadStatusScreen>((event, emit) async {
      add(LoadStatus());

      devicesRepository.listenForState((state) {
        if (state == BluetoothState.STATE_OFF) {
          event.onDisconnect();
        }
      });
      await _dbInstance.listen((data, dioError) {
        add(LoadStatus());
        isar.addControllerData(data);
        internetConnection = false;
      }, () {
        counter++;
        internetConnection = true;
        add(LoadStatus());
      });
      devicesRepository.listenForData((data) {
        if (data.contains(ascii.encode('{').first) &&
            data.contains(ascii.encode('}').first)) {
          var endOfFirst = data.indexOf(ascii.encode('}').first) + 1;
          var begOfSecond = data.indexOf(ascii.encode('{').first);
          if (isReceiving) {
            dataBuffer += ascii.decode(data.sublist(0, endOfFirst));
            sendingData = dataBuffer;
            _dbInstance.sendControllerData(sendingData, '123');
          }
          dataBuffer = ascii.decode(data.sublist(begOfSecond));
        } else {
          if (data.contains(ascii.encode('{').first) && isReceiving == false) {
            isReceiving = true;
            dataBuffer = "";
          }
          dataBuffer += ascii.decode(data);
          if (data.contains(ascii.encode('}').first) && isReceiving == true) {
            isReceiving = false;
            sendingData = dataBuffer;
            _dbInstance.sendControllerData(sendingData, '123');
          }
        }
      }, () {
        if (devicesRepository.disconnectionSource() == false) {
          event.onDisconnect();
        }
      });
    });

    on<LoadStatus>((event, emit) async {
      emit(StatusScreenLoaded(
          counter, await isar.getControllerDataSize(), internetConnection));
    });

  }

  String dataBuffer = "", sendingData = "";
  bool isReceiving = false;
  final AbstractBluetoothRepository devicesRepository;
}
