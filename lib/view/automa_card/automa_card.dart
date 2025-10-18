import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_action.dart';
import 'package:hegemon_companion/data/model/automa/automa_priority.dart';
import 'package:hegemon_companion/view/common/common_form.dart';
import 'package:hegemon_companion/view_model/automa_action_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_model/automa_priority_view_model.dart';
import '../automa/automa_priority_editor.dart';
import '../common/common.dart';
import '../common/priority_card.dart';

// Work in Progress

class AutomaCard extends StatelessWidget {
  const AutomaCard({super.key});

  void submit(BuildContext context, AutomaActionViewModel aaVM, AutomaPriorityViewModel apVM, String s) {
    // FIXME
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('N: $s')));
    AutomaActionCheckItem aci = aaVM.getNextStep().items[0];
    var actions = AutomaActionCheck.checkForeignMarket.applyCheck({aci.identifier: aci.toValue(s)});
    actions.forEach((action) {
      apVM.updatePriority(action.automaDecisionItem, (level) => level + action.levelChange);
      apVM.collapse();
      apVM.saveChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Common.backgroundColor,
      appBar: AppBar(
        backgroundColor: Common.appBarColor,
        foregroundColor: Common.textColor,
        title: const Text('Automa Card'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: Consumer2<AutomaActionViewModel, AutomaPriorityViewModel>(builder: (context, aaVM, apVM, child) {
                // TODO: support several items
                AutomaActionCheckItem aci = aaVM.getNextStep().items[0];
                return CommonForm(submit: (s) => submit(context, aaVM, apVM, s), items: [CommonFormItem(aci.question, aci.validate)]);
              }),
            )),
            // ElevatedButton(onPressed: () => {}, child: Text('Done', style: TextStyle(color: Colors.black))),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Consumer<AutomaPriorityViewModel>(
                builder: (context, viewModel, child) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AutomaPriorityEditor()),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Row(
                            children: viewModel
                                .getTopPriorities(AutomaDecisionItemType.action, 2)
                                .map((adi) => PriorityCard(automaDecisionItem: adi))
                                .toList()),
                      ),
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: viewModel
                                .getTopPriorities(AutomaDecisionItemType.policy, 2)
                                .map((adi) => PriorityCard(automaDecisionItem: adi))
                                .toList()),
                      ),
                    ]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
