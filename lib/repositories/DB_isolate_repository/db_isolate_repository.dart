import 'dart:async';
import 'dart:isolate';
import 'package:dart_ping/dart_ping.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_tech_mobile/repositories/local_data_base/local_db_repository.dart';

class DBIsolateRepository {
  ReceivePort? _receivePort;
  Isolate? _isolate;
  SendPort? _isolateSendPort;
  StreamSubscription<dynamic>? messagesSubscription;
  static final Dio _dio = Dio(BaseOptions(
    baseUrl:
        'https://data.binance.com/api/v3/ticker', // there should be URL of our endpoint sender
  ));

  DBIsolateRepository();

  Future _spawnIsolate() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_remoteIsolate, _receivePort!.sendPort,
        debugName: "remoteIsolate");
  }

  static void _remoteIsolate(SendPort port) {
    var sendPort = port;
    ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);
    isolateReceivePort.listen((message) async {
      if (message is List) {
        if (message[0] == 'send') {
          late Response resp;
          try {
            resp = await _dio.get('/24hr');
          } catch (error) {
            if (error is DioError) {
              sendPort.send([error, message[1]]);
            }
            return;
          }
          sendPort.send(resp.statusCode);
          return;
        }
        sendPort.send('Request in isolate error.');
        throw UnimplementedError();
      }
      // Updating of the send subscription
      if (message is SendPort) {
        sendPort.send(message.toString());
        sendPort = message;
        sendPort.send(message.toString());
      }
    });
  }

  Future<void> sendControllerData(String data, String token) async {
    final isar = LocalDBRepository();
    if (_isolate != null) {
      final ping = Ping('data.binance.com', count: 1);
      ping.stream.listen((event) async {
        if (event.summary != null) {
          // debugPrint('ping summary ${event.summary}');
          var localData = await isar.getControllerDataSizeAndDelete();
          for (var i in localData) {
            debugPrint(i?.dataJSON);
            _isolateSendPort?.send(['send', i?.dataJSON, token]);
          }
        }
      });
      _isolateSendPort?.send(['send', data, token]);
    } else {
      throw IsolateSpawnException('Isolate should be spawned.');
    }
  }

  Future<void> listen(void Function(String, DioError) onError,
      void Function() onSuccess) async {
    _isolate?.kill();
    _spawnIsolate();

    messagesSubscription = _receivePort?.listen((message) {
      if (message is SendPort) {
        _isolateSendPort = message;
      }
      if (message is int?) {
        if (message == 200) {
          onSuccess();
        } else {
          throw UnimplementedError();
        }
      }
      if (message is List) {
        onError(message[1] as String, message[0] as DioError);
      }
    });
  }
}
