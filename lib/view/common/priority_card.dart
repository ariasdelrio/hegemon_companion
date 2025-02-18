import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_priority.dart';
import 'package:hegemon_companion/view/common/common.dart';

class PriorityCard extends StatelessWidget {
  final AutomaDecisionItem automaDecisionItem;

  const PriorityCard({
    super.key,
    required this.automaDecisionItem,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 70),
        child: Card(
            elevation: 5,
            color: Color(automaDecisionItem.colorARGB),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(automaDecisionItem.code, style: const TextStyle(color: Common.textColor)),
            ))));
  }
}
