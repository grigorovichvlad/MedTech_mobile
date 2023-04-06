import 'package:flutter/material.dart';

class BluetoothDevices extends StatefulWidget {
  const BluetoothDevices({Key? key}) : super(key: key);

  @override
  State<BluetoothDevices> createState() => _BluetoothDevicesState();
}

Widget bluetoothCardTemplate(TextStyle? textStyle) {
  textStyle ??= const TextStyle(
      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14);
  return Row(
    children: [
      Column(
        children: <Widget>[
          Text(
            'Device name',
            style: textStyle,
          ),
          Text(
            'Description',
            style: textStyle,
          ),
        ],
      ),
    ],
  );
}

class _BluetoothDevicesState extends State<BluetoothDevices> {
  List<Widget> txt = [];

  void fun(TextStyle? textStyle) {
    for (int i = 0; i < 1000; i++) {
      txt.add(
        bluetoothCardTemplate(textStyle),
      );
      txt.add(Divider(height: 10));
    }
  }

  /*@override
  void initState() {
    super.initState();

  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    fun(textTheme.labelSmall);
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
