import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';

part 'status_screen_event.dart';

part 'status_screen_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc(this.devicesRepository) : super(StatusScreenInitial()) {
    on<LoadStatusScreen>((event, emit) {
      devicesRepository.listenForData((data) {
        if (data.contains(ascii.encode('{').first) && data.contains(ascii.encode('}').first)) {
          var endOfFirst = data.indexOf(ascii.encode('}').first) + 1;
          var begOfSecond = data.indexOf(ascii.encode('{').first);
          if (isReceiving) {
            dataBuffer += ascii.decode(data.sublist(0, endOfFirst));
            onScreen = dataBuffer;
            add(LoadDataInDB());
          }
          dataBuffer = ascii.decode(data.sublist(begOfSecond));
        }
        else {
          if (data.contains(ascii.encode('{').first) && isReceiving == false) {
            isReceiving = true;
            dataBuffer = "";
          }
          dataBuffer += ascii.decode(data);
          if (data.contains(ascii.encode('}').first) && isReceiving == true) {
            isReceiving = false;
            onScreen = dataBuffer;
            add(LoadDataInDB());
          }
        }
      });
    });

    on<LoadDataInDB>((event, emit) {
      var isar = LocalDBRepository();
      isar.addControllerData(onScreen.trim());
        //emit(StatusScreenLoaded(onScreen.trim()));
    });
  }

  String dataBuffer = "", onScreen = "";
  bool isReceiving = false;
  final AbstractBluetoothRepository devicesRepository;
}
