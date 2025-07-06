import 'package:cryptochat/features/shared/utils/themes/themes.dart';
import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,

  String? title,
  String? content,
  required DialogOptionBuilder optionsBuilder,
  AlignmentGeometry? buttonAlignment,
}) async {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return _GenericDialog(
        options: options,
        title: title,

        content: content,
        optionsBuilder: optionsBuilder,
        buttonAlignment: buttonAlignment,
      );
    },
  );
}

class _GenericDialog extends StatefulWidget {
  final Map<String, dynamic> options;
  final String? title;

  final String? content;
  final DialogOptionBuilder optionsBuilder;
  final AlignmentGeometry? buttonAlignment;

  const _GenericDialog({
    required this.options,
    required this.title,

    required this.content,
    required this.optionsBuilder,
    required this.buttonAlignment,
  });
  @override
  State<_GenericDialog> createState() => _GenericDialogState();
}

class _GenericDialogState extends State<_GenericDialog> {
  bool neverShowAgain = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: CustomColors.bubleGrey,
          title: widget.title != null
              ? Text(
                  widget.title!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                )
              : const SizedBox.shrink(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.content != null)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.content!),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          actions: widget.options.keys.map((optionTitle) {
            final value = widget.options[optionTitle];
            return Container(
              alignment: widget.buttonAlignment,
              child: TextButton(
                onPressed: () {
                  if (value != null) {
                    Navigator.of(context).pop(value);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  optionTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
