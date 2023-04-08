import 'package:get_it/get_it.dart';
import 'package:med_tech_mobile/features/devices_list/bloc/devices_list_bloc.dart';
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
          device.name.toString(),
          style:  const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
      ),
      subtitle: Text(
        device.id.toString(),
        style: theme.textTheme.labelSmall,
      ),
      // trailing: const Icon(Icons.arrow_forward_ios),
      onTap: (){

      },
    );
  }
}