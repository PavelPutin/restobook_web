import 'package:flutter/material.dart';

class InfoLabel extends StatelessWidget {
  const InfoLabel({super.key, required this.label, required this.info});

  final String label;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                softWrap: true,
              )),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: Text(
                info,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.fade,
              )),
            ],
          )
        ],
      ),
    );
  }
}
