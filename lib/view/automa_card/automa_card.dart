import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_priority.dart';
import 'package:provider/provider.dart';

import '../../view_model/automa_priority_view_model.dart';
import '../automa/automa_priority_editor.dart';
import '../common/common.dart';
import '../common/priority_card.dart';

// Work in Progress

class AutomaCard extends StatelessWidget {
  const AutomaCard({super.key});

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
                    child: Text('Work in Progress', style: TextStyle(color: Common.textColor)))),
            ElevatedButton(onPressed: () => {}, child: Text('Done', style: TextStyle(color: Colors.black))),
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
