import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key, required this.onAgree, this.query})
      : super(key: key);
  final Function onAgree;
  final String? query;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text('Подтверждение'),
          content: query == null ? null : Text(query!),
          actions: <Widget>[
            FilledButton(
              style: IconButton.styleFrom(
                highlightColor: Colors.grey[200],
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(true); // dismisses only the dialog and returns false
              },
              child: const Text('Да'),
            ),
            FilledButton(
              style: IconButton.styleFrom(
                highlightColor: Colors.blue[400],
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true)
                    .pop(false); // dismisses only the dialog and returns true
              },
              child: Text('Нет', style: textTheme.titleSmall),
            ),
          ],
        );
      },
    ).then(
        (result) {
          if (result == true) {
            onAgree();
          }
        }
    );
    return const CircularProgressIndicator();
  }
}
