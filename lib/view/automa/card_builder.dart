import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_action.dart';
import 'package:hegemon_companion/view/automa/automa_card.dart';
import 'package:hegemon_companion/view_model/automa_card_vm.dart';
import 'package:provider/provider.dart';

import '../../data/model/automa/automa_priority.dart';
import '../../view_model/automa_priority_vm.dart';
import '../common/common.dart';
import '../common/priority_card.dart';
import 'automa_priority_editor.dart';

typedef ActionCheckEntry = DropdownMenuEntry<ActionCheck>;
typedef SpecialCheckEntry = DropdownMenuEntry<SpecialCheck>;
typedef PolicyEntry = DropdownMenuEntry<AutomaDecisionItem>;

const String about = '''

A helper app for managing automas in the board game "Hegemony: Lead Your Class to Victory"

Licensed under the MIT License

Game components (texts and colours) used in the app were created by Hegemonic Project Games

Material Design and Icons by Google''';

class CardBuilder extends StatelessWidget {
  static final List<ActionCheckEntry> actionCheckEntries = ActionCheck.values
      .map((ac) => ActionCheckEntry(
            value: ac,
            label: ac.name,
          ))
      .toList();
  static final List<SpecialCheckEntry> specialCheckEntries = SpecialCheck.values
      .map((sc) => SpecialCheckEntry(
            value: sc,
            label: sc.name,
          ))
      .toList();
  static final List<PolicyEntry> policyEntries = AutomaDecisionItem.values
      .where((adi) => adi.type == AutomaDecisionItemType.policy)
      .map((p) => PolicyEntry(
            value: p,
            label: p.name,
          ))
      .toList();

  const CardBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Common.backgroundColor,
        appBar: AppBar(
            backgroundColor: Common.appBarColor,
            foregroundColor: Common.textColor,
            title: const Text('Card Builder'),
            actions: <Widget>[
              IconButton(
                  onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Hegemon Companion', style: TextStyle(fontWeight: FontWeight.bold),),
                                const Text(about),
                              ],
                            ),
                          ),
                        ),
                      ),
                  icon: const Icon(Icons.info),
                  tooltip: 'About')
            ]),
        body: SafeArea(
          child: Consumer<AutomaCardViewModel>(builder: (context, vm, child) {
            var children = _buildActionCheckSelection(context, vm);
            children.add(Expanded(child: SizedBox(width: 50)));
            children.add(Divider());
            children.add(_buildPrioritySummary(context));
            return Padding(
                padding: EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children));
          }),
        ));
  }

  List<Widget> _buildActionCheckSelection(BuildContext context, AutomaCardViewModel vm) {
    List<Widget> items = [
      DropdownMenu<ActionCheck>(
          textStyle: Common.textStyle,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
            labelStyle: Common.textStyle,
          ),
          dropdownMenuEntries: actionCheckEntries,
          initialSelection: vm.actionCheck,
          label: const Text('Action Check'),
          requestFocusOnTap: false,
          onSelected: (value) {
            if (value != null) {
              vm.setActionCheck(value);
            }
          })
    ];

    switch (vm.actionCheck) {
      case ActionCheck.policies:
        items.add(Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: DropdownMenu<AutomaDecisionItem>(
              textStyle: Common.textStyle,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                labelStyle: Common.textStyle,
              ),
              dropdownMenuEntries: policyEntries,
              initialSelection: vm.policy1,
              label: const Text('First Policy'),
              requestFocusOnTap: false,
              onSelected: (value) {
                if (value != null) {
                  vm.setPolicy1(value);
                }
              }),
        ));
        items.add(Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: DropdownMenu<AutomaDecisionItem>(
              textStyle: Common.textStyle,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                labelStyle: Common.textStyle,
              ),
              dropdownMenuEntries: policyEntries,
              initialSelection: vm.policy2,
              label: const Text('Second Policy'),
              requestFocusOnTap: false,
              onSelected: (value) {
                if (value != null) {
                  vm.setPolicy2(value);
                }
              }),
        ));
      case ActionCheck.special:
        items.add(Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: DropdownMenu<SpecialCheck>(
              textStyle: Common.textStyle,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                labelStyle: Common.textStyle,
              ),
              dropdownMenuEntries: specialCheckEntries,
              initialSelection: vm.specialCheck,
              label: const Text('Special Check'),
              requestFocusOnTap: false,
              onSelected: (value) {
                if (value != null) {
                  vm.setSpecialCheck(value);
                }
              }),
        ));
      default:
    }

    items.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: ElevatedButton(
            onPressed: () {
              if (vm.policy1 == vm.policy2) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    showCloseIcon: true,
                    content: Row(children: [
                      Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0), child: Icon(Icons.error, color: Colors.red)),
                      Common.label('Please select two different policies'),
                    ])));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AutomaCard()),
                );
              }
            },
            child: Text('Start'))));

    return items;
  }

  Widget _buildPrioritySummary(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Consumer<AutomaPriorityViewModel>(
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AutomaPriorityEditor()),
            ),
            child: Row(children: [
              Expanded(
                child: Row(
                    children: vm
                        .getTopPriorities(AutomaDecisionItemType.action, 2)
                        .map((adi) => PriorityCard(automaDecisionItem: adi))
                        .toList()),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: vm
                        .getTopPriorities(AutomaDecisionItemType.policy, 2)
                        .map((adi) => PriorityCard(automaDecisionItem: adi))
                        .toList()),
              ),
            ]),
          );
        },
      ),
    );
  }
}
