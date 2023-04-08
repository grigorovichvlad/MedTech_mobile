import 'package:med_tech_mobile/repositories/bluetooth_device/bluetooth_device.dart';
import 'package:flutter/material.dart';

class DeviceTile extends StatelessWidget{
  const DeviceTile({Key? key,
   required this.device,
}) : super(key: key);

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    final theme =  Theme.of(context);
    return ListTile(
      //leading: Image.network(coin.imageURL),
      title: Text(
          device.name,
          style: theme.textTheme.bodyMedium
      ),
      // subtitle: Text(
      //   '${device.id} \$',
      //   style: theme.textTheme.labelSmall,
      // ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: (){
        Navigator.of(context).pushNamed(
          '/device',
          arguments: device,
        );
      },
    );
  }
}