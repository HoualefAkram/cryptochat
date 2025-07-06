import 'package:cryptochat/features/chat/models/seed.dart';
import 'package:cryptochat/features/shared/utils/themes/themes.dart';

import 'package:flutter/material.dart';

Future<Seed?> showSeedDialog({
  required BuildContext context,
  int? initialRead,
  int? initialWrite,
}) async => showDialog<Seed?>(
  context: context,
  builder: (context) =>
      _SeedDialog(initialRead: initialRead, initialWrite: initialWrite),
);

class _SeedDialog extends StatefulWidget {
  final int? initialRead;
  final int? initialWrite;

  const _SeedDialog({required this.initialRead, required this.initialWrite});

  @override
  State<_SeedDialog> createState() => _SeedDialogState();
}

class _SeedDialogState extends State<_SeedDialog> {
  late final TextEditingController readSeedController;
  late final TextEditingController writeSeedController;

  @override
  void initState() {
    readSeedController = TextEditingController()
      ..text = (widget.initialRead ?? "").toString();
    writeSeedController = TextEditingController()
      ..text = (widget.initialWrite ?? "").toString();

    super.initState();
  }

  @override
  void dispose() {
    readSeedController.dispose();
    writeSeedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: CustomColors.bubleGrey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: readSeedController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Read seed",
              label: const Text("Read seed"),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: writeSeedController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Write seed",
              label: const Text("Write seed"),
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final int? readSeed = int.tryParse(readSeedController.text);
                  final int? writeSeed = int.tryParse(writeSeedController.text);
                  Navigator.of(
                    context,
                  ).pop(Seed(read: readSeed, write: writeSeed));
                },
                child: Text(
                  "Confirm",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
