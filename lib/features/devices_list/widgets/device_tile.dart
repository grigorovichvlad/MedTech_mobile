import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget{
  const DeviceTile({
   //super.key,
   required this.device,
});
  final BluetoothDevice device;

  // @override
  // Widget bluetoothCardTemplate(TextStyle? textStyle) {
  //   textStyle ??= const TextStyle(
  //       color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14);
  //   return Row(
  //     children: [
  //       Column(
  //         children: <Widget>[
  //           Text(
  //             'Device name',
  //             style: textStyle,
  //           ),
  //           Text(
  //             'Description',
  //             style: textStyle,
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        device.name,
        style: theme.textTheme.bodyMedium
      ),
    );
  }
}