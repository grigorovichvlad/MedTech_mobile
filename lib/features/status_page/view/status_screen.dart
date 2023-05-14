import 'package:flutter/material.dart';
import 'package:med_tech_mobile/features/widgets/confirmation_dialog.dart';
import 'package:med_tech_mobile/features/widgets/exit_button.dart';

import '../../../repositories/local_data_base/local_db_repository.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ConfirmationDialog(
                    onAgree: () {
                      Navigator.pushReplacementNamed(context, '/devices');
                    },
                    query: 'Вы точно хотите сменить устройство?')
                .build(context);
          },
          padding: const EdgeInsets.all(16.0),
          highlightColor: Colors.blue[400],
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
          icon: const Icon(Icons.devices, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Состояние',
          style: textTheme.headlineLarge,
        ),
        actions: [
          const ExitButton().build(context),
        ],
      ),
    );
  }
}
