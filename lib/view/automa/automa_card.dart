import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_action.dart';
import 'package:hegemon_companion/view/common/policy_position_input.dart';
import 'package:hegemon_companion/view/common/quantity_input.dart';
import 'package:provider/provider.dart';

import '../../data/model/automa/automa_priority.dart';
import '../../view_model/automa_card_vm.dart';
import '../common/common.dart';
import '../common/priority_card.dart';

class AutomaCard extends StatelessWidget {
  static final Color bcColor = Common.color(AutomaDecisionItem.buildCompany);
  static final Color scColor = Common.color(AutomaDecisionItem.sellCompany);

  const AutomaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AutomaCardViewModel>(builder: (context, vm, child) {
      return Scaffold(
          backgroundColor: Common.backgroundColor,
          appBar: AppBar(
            backgroundColor: Common.appBarColor,
            foregroundColor: Common.textColor,
            title: Text('Check ${vm.actionCheck.name}'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(8),
                  child: _buildForm(context, vm),
                )),
              ],
            ),
          ));
    });
  }

  Widget _buildForm(BuildContext context, AutomaCardViewModel vm) {
    List<Widget> rows = [];

    switch (vm.actionCheck) {
      case ActionCheck.foreignMarket:
        rows.add(Common.formRow(
            'Number of possible transactions',
            QuantityInput(
              label: 'Number of possible transactions',
              color: Common.color(AutomaDecisionItem.sellToTheForeignMarket),
              getValue: () => vm.possibleForeignMarketTransactions,
              setValue: vm.setPossibleForeignMarketTransactions,
              minValue: 0,
              maxValue: 9,
            )));
      case ActionCheck.influence:
        rows.add(
          Common.formRow('At least one Bill proposed',
              Common.checkbox(Common.color(AutomaDecisionItem.lobby), vm.billProposed, vm.setBillProposed)),
        );
        if (vm.billProposed) {
          rows.add(Common.formRow(
              'Influence other players',
              QuantityInput(
                label: 'Influence other players',
                color: Common.color(AutomaDecisionItem.lobby),
                getValue: () => vm.influenceOtherPlayers,
                setValue: vm.setInfluenceOtherPlayers,
                minValue: 0,
              )));
          rows.add(Common.formRow(
              'Influence CC',
              QuantityInput(
                label: 'Influence CC',
                color: Common.color(AutomaDecisionItem.lobby),
                getValue: () => vm.influenceCC,
                setValue: vm.setInfluenceCC,
                minValue: 0,
              )));
        }
      case ActionCheck.policies:
        rows.add(Common.formRow(
            vm.policy1.name,
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: PolicyPositionInput(
                  policy: vm.policy1,
                  getValue: () => vm.policy1Position,
                  setValue: vm.setPolicy1Position,
                  withSetAside: true),
            )));
        rows.add(Common.formRow(
            vm.policy2.name,
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: PolicyPositionInput(
                  policy: vm.policy2,
                  getValue: () => vm.policy2Position,
                  setValue: vm.setPolicy2Position,
                  withSetAside: true),
            )));
      case ActionCheck.companies:
        bool askNumberOfProductionPhases = false;

        rows.add(Common.label('Market'));
        List<Widget> market = [];
        for (int i = 0; i < ActionCheckService.marketSize; i++) {
          if (vm.getMarketCompaniesStatus(i) != MarketCompaniesStatus.producesNothing) {
            askNumberOfProductionPhases = true;
          }
          market.add(_buildMarketCompanyCard(vm, i));
        }
        rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: market));

        rows.add(Common.formRow('Demonstration is taking place',
            Common.checkbox(bcColor, vm.demonstrationTakingPlace, vm.setDemonstrationTakingPlace)));

        rows.add(Common.label('Non-operational companies'));
        List<Widget> nonOperationalCompanies = [];
        for (int i = 0; i < vm.numberOfNonOperationalCompanies; i++) {
          nonOperationalCompanies.add(_buildNonOperationalCompanyCard(vm, context, i));
        }
        if (vm.numberOfNonOperationalCompanies < AutomaCardViewModel.maxNumberOfCompanies) {
          nonOperationalCompanies.add(_buildNewNonOperationalCompanyCard(vm, context));
        }

        List<Widget> currentRow = [];
        for (int i = 0; i < nonOperationalCompanies.length; i++) {
          if (i > 0 && i % 4 == 0) {
            rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: currentRow));
            currentRow = [];
          }
          currentRow.add(nonOperationalCompanies[i]);
        }

        int extraCards = currentRow.length;
        if (extraCards > 0) {
          for (int i = 0; i < 4 - extraCards; i++) {
            currentRow.add(_buildCompanyPlaceholder());
          }
          rows.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: currentRow));
        }

        if (askNumberOfProductionPhases) {
          rows.add(Common.formRow(
              'Production phases remaining',
              QuantityInput(
                  label: 'Production phases remaining',
                  color: Common.color(AutomaDecisionItem.buildCompany),
                  getValue: () => vm.productionPhasesRemaining,
                  setValue: vm.setProductionPhasesRemaining,
                  minValue: 0,
                  maxValue: 5)));
        }
      case ActionCheck.special:
        switch (vm.specialCheck) {
          case SpecialCheck.automation:
            rows.add(Common.formRow(
                'Companies that could get an Automation token',
                QuantityInput(
                    label: 'Companies that could get an Automation token',
                    color: Common.color(AutomaDecisionItem.specialAction),
                    getValue: () => vm.eligibleCompanies,
                    setValue: vm.setEligibleCompanies,
                    minValue: 0,
                    maxValue: 12)));
            if (vm.eligibleCompanies > 0) {
              rows.add(Common.formRow(
                  'Production phases remaining',
                  QuantityInput(
                      label: 'Production phases remaining',
                      color: Common.color(AutomaDecisionItem.specialAction),
                      getValue: () => vm.productionPhasesRemaining,
                      setValue: vm.setProductionPhasesRemaining,
                      minValue: 0,
                      maxValue: 5)));
            }
          case SpecialCheck.luxury:
            rows.add(Common.formRow(
                'Amount of Luxury',
                QuantityInput(
                    label: 'Amount of Luxury',
                    color: Common.color(AutomaDecisionItem.specialAction),
                    getValue: () => vm.luxury,
                    setValue: vm.setLuxury,
                    minValue: 0,
                    maxValue: 5)));
            if (vm.luxury >= 3) {
              rows.add(Common.formRow(
                  'CC has Influence',
                  Common.checkbox(
                      Common.color(AutomaDecisionItem.specialAction), vm.hasInfluence, vm.setHasInfluence)));
            }
          case SpecialCheck.revenue:
            rows.add(Common.formRow(
                'Revenue',
                QuantityInput(
                    label: 'Revenue',
                    color: Common.color(AutomaDecisionItem.specialAction),
                    getValue: () => vm.revenue,
                    setValue: vm.setRevenue,
                    minValue: 0)));
            if (vm.revenue >= 150) {
              rows.add(Common.formRow(
                  AutomaDecisionItem.taxation.name,
                  PolicyPositionInput(
                      policy: AutomaDecisionItem.taxation,
                      getValue: () => vm.taxationPosition,
                      setValue: vm.setTaxationPosition,
                      withSetAside: false)));
            }
          case SpecialCheck.politicalPressure:
            rows.add(Common.formRow(
                AutomaDecisionItem.foreignTrade.name,
                PolicyPositionInput(
                    policy: AutomaDecisionItem.foreignTrade,
                    getValue: () => vm.foreignTradePosition,
                    setValue: vm.setForeignTradePosition,
                    withSetAside: false)));
            if (vm.foreignTradePosition != 'C') {
              rows.add(Common.formRow(
                  'Agricultural Companies',
                  QuantityInput(
                      label: 'Agricultural Companies',
                      color: Common.color(AutomaDecisionItem.specialAction),
                      getValue: () => vm.agriculturalCompanies,
                      setValue: vm.setAgriculturalCompanies,
                      minValue: 0,
                      maxValue: 12)));
              if (vm.foreignTradePosition != 'B') {
                rows.add(Common.formRow(
                    'Luxury Companies',
                    QuantityInput(
                        label: 'Luxury Companies',
                        color: Common.color(AutomaDecisionItem.specialAction),
                        getValue: () => vm.luxuryCompanies,
                        setValue: vm.setLuxuryCompanies,
                        minValue: 0,
                        maxValue: 12)));
              }
            }
        }
    }

    rows.add(Divider());

    rows.add(Common.label('Adjust Priorities:'));
    rows.addAll(vm.getPriorityAdjustments().map((priorityChange) => Row(children: [
          PriorityCard(automaDecisionItem: priorityChange.automaDecisionItem),
          Common.label('+${priorityChange.levelChange}'),
        ])));

    return Padding(padding: EdgeInsets.all(10), child: ListView(children: rows));
  }

  Widget _buildMarketCompanyCard(AutomaCardViewModel vm, int index) {
    return _buildCompanyCard(() {
      if (vm.getMarketCompaniesStatus(index) == MarketCompaniesStatus.producesNothing) {
        vm.setMarketCompaniesStatus(index, MarketCompaniesStatus.producesMoreOfSomething);
      } else if (vm.getMarketCompaniesStatus(index) == MarketCompaniesStatus.producesMoreOfSomething) {
        vm.setMarketCompaniesStatus(index, MarketCompaniesStatus.producesSomethingNew);
      } else if (vm.getMarketCompaniesStatus(index) == MarketCompaniesStatus.producesSomethingNew) {
        vm.setMarketCompaniesStatus(index, MarketCompaniesStatus.producesNothing);
      }
    }, Common.color(AutomaDecisionItem.buildCompany),
        Icon(vm.getMarketCompaniesStatus(index).icon, color: Common.textColor));
  }

  Widget _buildNonOperationalCompanyCard(AutomaCardViewModel vm, BuildContext context, int index) {
    return _buildCompanyCard(() async {
      int? newValue =
          await showDialog(context: context, builder: (context) => SellValueInputDialog(removeAllowed: true));
      if (newValue != null) {
        if (newValue == -1) {
          vm.removeNonOperationalCompanyAt(index);
        } else {
          vm.setSellValue(index, newValue);
        }
      }
    }, Common.color(AutomaDecisionItem.sellCompany), Center(child: Common.label(vm.getSellValue(index).toString())));
  }

  Widget _buildNewNonOperationalCompanyCard(AutomaCardViewModel vm, BuildContext context) {
    return _buildCompanyCard(() async {
      int? newValue =
          await showDialog(context: context, builder: (context) => SellValueInputDialog(removeAllowed: false));
      if (newValue != null) {
        vm.addNonOperationalCompany(newValue);
      }
    }, Colors.grey, Icon(Icons.add, color: Common.textColor));
  }

  Widget _buildCompanyCard(void Function()? onTap, Color color, Widget content) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Card(
            elevation: 5,
            color: color,
            child: AspectRatio(aspectRatio: 1, child: content),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyPlaceholder() {
    return Flexible(
      child: SizedBox(width: 100),
    );
  }
}

class SellValueInputDialog extends StatefulWidget {
  final bool removeAllowed;

  const SellValueInputDialog({super.key, required this.removeAllowed});

  @override
  State<SellValueInputDialog> createState() => _SellValueInputDialogState();
}

class _SellValueInputDialogState extends State<SellValueInputDialog> {
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
    List<Widget> actions = [];
    if (widget.removeAllowed) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.of(context).pop(-1);
        },
        child: Common.label('REMOVE COMPANY'),
      ));
    }
    actions.add(TextButton(
      onPressed: () {
        Navigator.of(context).pop(int.tryParse(controller.text));
      },
      child: Common.label('OK'),
    ));
    return AlertDialog(
      backgroundColor: Common.color(AutomaDecisionItem.sellCompany),
      title: HCText(text: 'Sell Company Value'),
      content: HCNumberInput(controller: controller),
      actions: actions,
    );
  }
}
