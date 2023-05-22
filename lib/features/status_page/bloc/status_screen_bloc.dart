import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  StatusBloc(this.devicesRepository) : super(StatusScreenInitial()) {
    on<LoadStatusScreen>((event, emit) async {
      await _dbInstance.listen((data, dioError) {
        debugPrint(dioError.toString());
        isar.addControllerData(data);
      }, () {
        counter++;
        add(LoadStatus());
        debugPrint('Sent');
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
      });
    });

    on<LoadStatus>((event, emit) {
      emit(StatusScreenLoaded('Amount of successful requests: ${counter.toString()}'));
    });
  }

  String dataBuffer = "", sendingData = "";
  bool isReceiving = false;
  final AbstractBluetoothRepository devicesRepository;
}
