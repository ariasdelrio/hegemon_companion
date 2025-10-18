import 'package:flutter/material.dart';

import 'common.dart';

class QuantityInput extends StatelessWidget {
  final String label;
  final Color color;
  final int Function() getValue;
  final void Function(int) setValue;
  final int? minValue;
  final int? maxValue;

  const QuantityInput({
    super.key,
    required this.label,
    required this.color,
    required this.getValue,
    required this.setValue,
    this.minValue,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          icon: Icon(
            Icons.remove_circle_outline,
          ),
          color: color,
          disabledColor : Colors.grey,
          onPressed: isDecrementEnabled() ? () => updateValue(getValue() - 1) : null),
      GestureDetector(
        onTap: () async {
          int? newValue = await showDialog(
              context: context,
              builder: (context) => QuantityInputDialog(
                    label: label,
                    color: color,
                  ));
          if (newValue != null) {
            updateValue(newValue);
          }
        },
        child: Card(
            elevation: 5,
            color: color,
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4), child: HCText(text: getValue().toString())))),
      ),
      IconButton(
          icon: Icon(
            Icons.add_circle_outline,
          ),
          color: color,
          disabledColor : Colors.grey,
          onPressed: isIncrementEnabled() ? () => updateValue(getValue() + 1) : null),
    ]);
  }

  void updateValue(int newValue) {
    if (minValue case final int x) {
      if (newValue < x) {
        return;
      }
    }
    if (maxValue case final int x) {
      if (newValue > x) {
        return;
      }
    }
        setValue(newValue);
  }

  bool isDecrementEnabled() {
    return minValue == null || getValue() != minValue;
  }

  bool isIncrementEnabled() {
    return maxValue == null || getValue() != maxValue;
  }
}

class QuantityInputDialog extends StatefulWidget {
  final String label;
  final Color color;

  const QuantityInputDialog({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  State<QuantityInputDialog> createState() => _QuantityInputDialogState();
}

class _QuantityInputDialogState extends State<QuantityInputDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.color,
      title: HCText(text: widget.label),
      content: HCNumberInput(controller: controller),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(int.tryParse(controller.text));
          },
          child: Common.label('OK'),
        ),
      ],
    );
  }
}
