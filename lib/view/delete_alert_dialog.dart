import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatefulWidget {
  const DeleteAlertDialog(
      {super.key,
      required this.title,
      required this.onSubmit,
      required this.successLabel,
      required this.errorLabel});

  final Widget title;
  final AsyncCallback onSubmit;
  final String successLabel;
  final String errorLabel;

  @override
  State<DeleteAlertDialog> createState() => _DeleteAlertDialogState();
}

class _DeleteAlertDialogState extends State<DeleteAlertDialog> {
  Future<void> deleting = Future.delayed(const Duration(seconds: 0));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_forever),
      title: widget.title,
      content: const Text("Внимание! Это действие нельзя отменить"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
        TextButton(
            onPressed: () async {
              // var promise = context
              //     .read<TableViewModel>()
              //     .delete(context.read<TableViewModel>().activeTable!);
              var promise = widget.onSubmit();
              setState(() {
                deleting = promise;
              });
              await promise.then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(widget.successLabel)));
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Стол удалён")));
              }).onError((error, stackTrace) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(widget.errorLabel)));
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Не удалось удалить стол")));
              });
            },
            child: FutureBuilder(
              future: deleting,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return Text("Удалить",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.error));
              },
            )),
      ],
    );
  }
}
