import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_priority.dart';

import 'common.dart';

class PolicyPositionInput extends StatelessWidget {
  static const List<String> baseOptions = ['A', 'B', 'C'];
  static const List<String> setAside = ['X'];

  final AutomaDecisionItem policy;
  final String Function() getValue;
  final void Function(String) setValue;
  final List<String> options;

  const PolicyPositionInput({
    super.key,
    required this.policy,
    required this.getValue,
    required this.setValue,
    bool withSetAside = false,
  }) : options = baseOptions + (withSetAside ? setAside : const []);


  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
        segments: options.map(buildSegment).toList(),
        selected: {getValue()},
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
            foregroundColor: Common.textColor,
            selectedForegroundColor: Common.textColor,
            selectedBackgroundColor: Common.color(policy),
            side: BorderSide(color: Common.color(policy)),
            textStyle: TextStyle(
              fontStyle: FontStyle.normal,
            ),
            visualDensity: VisualDensity(horizontal: -3, vertical: -3)),
        onSelectionChanged: (Set<String> newSelection) {
          setValue(newSelection.first);
        });
  }

  ButtonSegment<String> buildSegment(String option) {
    return ButtonSegment<String>(value: option, label: (option == 'X' ? Icon(Icons.block) : Text(option)));
  }
}
