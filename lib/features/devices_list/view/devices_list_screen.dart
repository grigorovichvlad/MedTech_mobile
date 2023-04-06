import 'package:flutter/material.dart';

class BluetoothDevices extends StatefulWidget {
  const BluetoothDevices({Key? key}) : super(key: key);

  @override
  State<BluetoothDevices> createState() => _BluetoothDevicesState();
}


Widget bluetoothCardTemplate() {
  return Container(
    child: Row(
      children: [
        Column(
          children: <Widget>[
            Text('Device name'),
            Text('Description'),
          ],
        ),
      ],
    ),
  );
}

class _BluetoothDevicesState extends State<BluetoothDevices> {

  List<Widget> txt = [];

  void fun() {
    for (int i = 0; i < 1000; i++) {
      txt.add(
        bluetoothCardTemplate(),
      );
      txt.add(Divider(height: 10));
    }
  }

  @override
  void initState() {
    super.initState();
    fun();
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
        title: const Text(
          'Доступные устройства',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: txt.toList(),
        ),
      ),
    );
  }
}
