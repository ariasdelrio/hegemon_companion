import 'package:hegemon_companion/data/model/automa/automa_priority.dart';
import 'package:test/test.dart';

void main() {
  test('constructor', () {
    expect(() => AutomaPriority([]), throwsArgumentError);
    expect(() => AutomaPriority([AutomaPriorityItem(AutomaDecisionItem.laborMarket, -1)]), throwsArgumentError);
    expect(() => AutomaPriority([AutomaPriorityItem(AutomaDecisionItem.specialAction, 0)]), throwsArgumentError);
  });

  test('maxLevel', () {
    final ap1 = AutomaPriority([
      AutomaPriorityItem(AutomaDecisionItem.education, 1),
      AutomaPriorityItem(AutomaDecisionItem.fiscalPolicy, 5),
      AutomaPriorityItem(AutomaDecisionItem.taxation, 2),
      AutomaPriorityItem(AutomaDecisionItem.laborMarket, 0)
    ]);
    expect(ap1.maxLevel, 5);

    final ap2 = AutomaPriority([AutomaPriorityItem(AutomaDecisionItem.laborMarket, 10)]);
    expect(ap2.maxLevel, 10);
  });

  test('getDecisionItems', () {
    final ap = AutomaPriority([
      AutomaPriorityItem(AutomaDecisionItem.education, 1),
      AutomaPriorityItem(AutomaDecisionItem.fiscalPolicy, 5),
      AutomaPriorityItem(AutomaDecisionItem.taxation, 2),
      AutomaPriorityItem(AutomaDecisionItem.lobby, 2),
      AutomaPriorityItem(AutomaDecisionItem.laborMarket, 0),
      AutomaPriorityItem(AutomaDecisionItem.healthcare, 2),
      AutomaPriorityItem(AutomaDecisionItem.sellToTheForeignMarket, 2),
      AutomaPriorityItem(AutomaDecisionItem.immigration, 2)
    ]);

    expect(ap.getDecisionItems(AutomaDecisionItemType.policy, 1), [AutomaDecisionItem.education]);
    expect(ap.getDecisionItems(AutomaDecisionItemType.policy, 2),
        [AutomaDecisionItem.taxation, AutomaDecisionItem.healthcare, AutomaDecisionItem.immigration]);
    expect(ap.getDecisionItems(AutomaDecisionItemType.policy, 2),
        [AutomaDecisionItem.taxation, AutomaDecisionItem.healthcare, AutomaDecisionItem.immigration]);
    expect(ap.getDecisionItems(AutomaDecisionItemType.action, 2),
        [AutomaDecisionItem.lobby, AutomaDecisionItem.sellToTheForeignMarket]);
  });

  test('adjustItemPriority', () {
    final ap1 = AutomaPriority([
      AutomaPriorityItem(AutomaDecisionItem.education, 1),
      AutomaPriorityItem(AutomaDecisionItem.fiscalPolicy, 5),
      AutomaPriorityItem(AutomaDecisionItem.taxation, 2),
      AutomaPriorityItem(AutomaDecisionItem.immigration, 3),
      AutomaPriorityItem(AutomaDecisionItem.lobby, 5),
    ]);

    final ap2 = ap1.adjustItemPriority(AutomaDecisionItem.education, (level) => 3);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 2), [AutomaDecisionItem.taxation]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 5), [AutomaDecisionItem.fiscalPolicy]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 1), []);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 3),
        [AutomaDecisionItem.immigration, AutomaDecisionItem.education]);

    expect(
        ap1
            .adjustItemPriority(AutomaDecisionItem.lobby, (level) => level - 10)
            .getDecisionItems(AutomaDecisionItemType.action, 1)
            .firstOrNull,
        AutomaDecisionItem.lobby);
  });

  test('collapse', () {
    final ap1 = AutomaPriority([
      AutomaPriorityItem(AutomaDecisionItem.education, 1),
      AutomaPriorityItem(AutomaDecisionItem.lobby, 2),
      AutomaPriorityItem(AutomaDecisionItem.buildCompany, 2),
      AutomaPriorityItem(AutomaDecisionItem.taxation, 2),
      AutomaPriorityItem(AutomaDecisionItem.immigration, 3),
      AutomaPriorityItem(AutomaDecisionItem.fiscalPolicy, 5),
      AutomaPriorityItem(AutomaDecisionItem.sellToTheForeignMarket, 4),
    ]);

    final AutomaPriority ap2 = ap1.collapse();
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 1), [AutomaDecisionItem.education]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 2), [AutomaDecisionItem.taxation]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 3), [AutomaDecisionItem.immigration]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.policy, 4), [AutomaDecisionItem.fiscalPolicy]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.action, 1),
        [AutomaDecisionItem.lobby, AutomaDecisionItem.buildCompany]);
    expect(ap2.getDecisionItems(AutomaDecisionItemType.action, 2), [AutomaDecisionItem.sellToTheForeignMarket]);
    expect(ap2.maxLevel, 4);
  });
}
