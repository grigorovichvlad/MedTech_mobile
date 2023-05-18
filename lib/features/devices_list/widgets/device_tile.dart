
import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget{
   const DeviceTile({Key? key,
   required this.device, required this.onTap,
}) : super(key: key);

  final BluetoothDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme =  Theme.of(context);
    final textTheme =  theme.textTheme;
    return ListTile(
      //leading: Image.network(coin.imageURL),
      title: Text(
          device.name.toString(),
          style: textTheme.bodyMedium,
      ),
      subtitle: Text(
        device.id.toString(),
        style: textTheme.bodySmall,
      ),
      // trailing: const Icon(Icons.arrow_forward_ios),
       onTap: onTap,
    );
  }
}