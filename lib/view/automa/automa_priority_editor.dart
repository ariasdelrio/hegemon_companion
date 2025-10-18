import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_priority.dart';
import 'package:provider/provider.dart';

import '../../view_model/automa_priority_view_model.dart';
import '../common/common.dart';
import '../common/priority_card.dart';

class AutomaPriorityEditor extends StatelessWidget {
  const AutomaPriorityEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Common.backgroundColor,
      appBar: AppBar(
        backgroundColor: Common.appBarColor,
        foregroundColor: Common.textColor,
        title: const Text('Automa Priority Editor'),
      ),
      body: SafeArea(
        child: PriorityChart(),
      ),
    );
  }
}

class PriorityChart extends StatelessWidget {
  const PriorityChart({super.key});

  Row _buildCollapseRow(AutomaPriorityViewModel viewModel) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      Center(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
            onTap: viewModel.collapse,
            child: const Icon(Icons.vertical_align_bottom, size: 30, color: Common.inactiveColor)),
      ))
    ]);
  }

  Widget _buildPriorityRowHalf(
      BuildContext context, AutomaPriorityViewModel viewModel, AutomaDecisionItemType type, int level) {
    var items = viewModel.getDecisionItems(type, level);
    return Row(
        mainAxisAlignment: type == AutomaDecisionItemType.action ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: (type == AutomaDecisionItemType.action ? items.reversed : items)
            .map((item) => Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      int? newLevel = await showDialog(
                        context: context,
                        builder: (BuildContext context) => ChangePriorityDialog(automaDecisionItem: item, level: level),
                      );
                      if (newLevel != null) {
                        viewModel.updatePriority(item, (_) => newLevel);
                      }
                    },
                    child: PriorityCard(automaDecisionItem: item),
                  ),
                ))
            .toList());
  }

  Row _buildPriorityRow(BuildContext context, AutomaPriorityViewModel viewModel, int level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(child: _buildPriorityRowHalf(context, viewModel, AutomaDecisionItemType.action, level)),
        const Center(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Icon(Icons.circle, size: 30, color: Color(0xFF6A7686)),
                  Icon(size: 20, Icons.radio_button_unchecked, color: Color(0xFFFFED7A)),
                ]))),
        Expanded(
          child: _buildPriorityRowHalf(context, viewModel, AutomaDecisionItemType.policy, level),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaPriorityViewModel>(builder: (context, viewModel, child) {
      var maxLevel = viewModel.maxPriorityLevel;
      var rows = [_buildCollapseRow(viewModel)];
      rows.addAll(List<int>.generate(maxLevel, (i) => maxLevel - i)
          .map((level) => _buildPriorityRow(context, viewModel, level)));

      var discardedPolicies = viewModel.getDecisionItems(AutomaDecisionItemType.policy, 0);

      final Widget widget;
      if (discardedPolicies.isEmpty) {
        widget = Align(alignment: Alignment.bottomCenter, child: ListView(shrinkWrap: true, children: rows));
      } else {
        widget = Align(
            alignment: Alignment.bottomCenter,
            child: Column(children: [
              Expanded(
                  child: Align(alignment: Alignment.bottomCenter, child: ListView(shrinkWrap: true, children: rows))),
              const Divider(
                indent: 10,
                color: Common.textColor,
              ),
              _buildPriorityRow(context, viewModel, 0)
            ]));
      }

      return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              return;
            }
            var shouldPop = true;
            if (viewModel.hasUnsavedChanges()) {
              shouldPop = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(content: Text('Save changes?'), actions: [
                        TextButton(
                          onPressed: () {
                            viewModel.dismissChanges();
                            Navigator.pop(context, true);
                          },
                          child: const Text('No', style: TextStyle(color: Colors.black)),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.saveChanges();
                            Navigator.pop(context, true);
                          },
                          child: const Text('Yes', style: TextStyle(color: Colors.black)),
                        ),
                      ]));
            }
            if (context.mounted && shouldPop) {
              Navigator.pop(context);
            }
          },
          child: widget);
    });
  }
}

class ChangePriorityDialog extends StatefulWidget {
  final AutomaDecisionItem automaDecisionItem;
  final int level;

  const ChangePriorityDialog({
    super.key,
    required this.automaDecisionItem,
    required this.level,
  });

  @override
  State<ChangePriorityDialog> createState() => _ChangePriorityDialogState();
}

class _ChangePriorityDialogState extends State<ChangePriorityDialog> {
  @override
  void initState() {
    super.initState();
    _automaDecisionItem = widget.automaDecisionItem;
    _level = widget.level;
  }

  late AutomaDecisionItem _automaDecisionItem;
  late int _level;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(_automaDecisionItem.colorARGB),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IntrinsicHeight(
              child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(_automaDecisionItem.name, style: const TextStyle(color: Common.textColor)),
                ),
                const VerticalDivider(
                  indent: 10,
                  color: Common.textColor,
                ),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                        onTap: () => {
                              setState(() {
                                _level += 1;
                              })
                            },
                        child: const Icon(Icons.arrow_drop_up, color: Common.textColor)),
                  ),
                  Text('$_level', style: const TextStyle(color: Common.textColor)),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                        onTap: () => {
                              setState(() {
                                _level =
                                    max(_level - 1, _automaDecisionItem.type == AutomaDecisionItemType.policy ? 0 : 1);
                              })
                            },
                        child: const Icon(Icons.arrow_drop_down, color: Common.textColor)),
                  ),
                ]),
              ]),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Common.textColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, _level);
                  },
                  child: const Text('Adjust priority', style: TextStyle(color: Common.textColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
