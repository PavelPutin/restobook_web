import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'delete_alert_dialog.dart';

class DeleteIconButton extends StatelessWidget {
  const DeleteIconButton(
      {super.key,
      required this.dialogTitle,
      required this.onSubmit,
      required this.successLabel,
      required this.errorLabel});

  final Widget dialogTitle;
  final AsyncCallback onSubmit;
  final String successLabel;
  final String errorLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return DeleteAlertDialog(
                  title: dialogTitle,
                  onSubmit: onSubmit,
                  successLabel: successLabel,
                  errorLabel: errorLabel,
                );
              });
        },
        color: Theme.of(context).colorScheme.error,
        icon: const Icon(Icons.delete_forever));
  }
}
