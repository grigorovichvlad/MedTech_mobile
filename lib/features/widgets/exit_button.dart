import 'package:flutter/material.dart';

import '../../repositories/local_data_base/local_db_repository.dart';
import 'confirmation_dialog.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ConfirmationDialog(
            onAgree: () {
              Navigator.pushReplacementNamed(context, '/');
              final isar =
              LocalDBRepository(); //'isar' - name of dataBase
              isar.deleteUserData();
            },
            query: 'Вы точно хотите выйти?')
            .build(context);
      },
      padding: const EdgeInsets.all(15.0),
      highlightColor: Colors.blue[400],
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      icon: const Icon(Icons.logout_rounded, color: Colors.white),
    );
  }
}
