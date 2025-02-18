import 'dart:math';
import 'package:collection/collection.dart';

class AutomaPriority {
  final List<AutomaPriorityItem> _items;

  const AutomaPriority._internal(this._items);

  factory AutomaPriority(Iterable<AutomaPriorityItem> items) {
    if (items.isEmpty) {
      throw ArgumentError('No items provided');
    }
    if (items.any((item) => item.level < item.decision.type.minLevel)) {
      throw ArgumentError('Level is too low');
    }
    return AutomaPriority._internal(List.unmodifiable(items));
  }

  int get maxLevel => _items.map((item) => item.level).reduce(max);

  List<AutomaDecisionItem> getDecisionItems(AutomaDecisionItemType type, int level) => _items
      .where((item) => item.level == level && item.decision.type == type)
      .toList()
      .map((item) => item.decision)
      .toList();

  AutomaPriority adjustItemPriority(AutomaDecisionItem decisionItem, int Function(int) adjustLevel) {
    var current = _items.firstWhereOrNull((item) => item.decision == decisionItem);
    if (current == null) {
      throw Exception('Priority ${decisionItem.name} not found');
    } else {
      return AutomaPriority(CombinedIterableView([
        _items.where((item) => item.decision != decisionItem),
        [AutomaPriorityItem(decisionItem, max(decisionItem.type.minLevel, adjustLevel(current.level)))]
      ]));
    }
  }

  AutomaPriority collapse() {
    var occupiedLevels = {
      AutomaDecisionItemType.action: <int>{},
      AutomaDecisionItemType.policy: <int>{},
    };
    var maxLevel = {
      AutomaDecisionItemType.action: 0,
      AutomaDecisionItemType.policy: 0,
    };
    for (var item in _items) {
      if (item.level > 0) {
        occupiedLevels[item.decision.type]?.add(item.level);
        maxLevel[item.decision.type] = max(maxLevel[item.decision.type] ?? 0, item.level);
      }
    }
    var levelMapping = {
      AutomaDecisionItemType.action: <int, int>{},
      AutomaDecisionItemType.policy: <int, int>{},
    };
    var nextLevel = {
      AutomaDecisionItemType.action: 1,
      AutomaDecisionItemType.policy: 1,
    };
    for (var type in AutomaDecisionItemType.values) {
      for (var level = 1; level <= maxLevel[type]!; level++) {
        if (occupiedLevels[type]!.contains(level)) {
          levelMapping[type]![level] = nextLevel[type]!;
          nextLevel[type] = nextLevel[type]! + 1;
        }
      }
    }

    return AutomaPriority([
      for (var item in _items) AutomaPriorityItem(item.decision, levelMapping[item.decision.type]![item.level] ?? 0)
    ]);
  }
}

class AutomaPriorityItem {
  final AutomaDecisionItem decision;
  final int level;

  const AutomaPriorityItem(this.decision, this.level);
}

enum AutomaDecisionItem {
  buildCompany(AutomaDecisionItemType.action, 'BC', 'Build Company', 0xFF22A3DB),
  proposeBill(AutomaDecisionItemType.action, 'PB', 'Propose Bill', 0xFFAEB0AF),
  specialAction(AutomaDecisionItemType.action, 'SA', 'Special Action', 0xFFED66A8),
  lobby(AutomaDecisionItemType.action, 'LOB', 'Lobby', 0xFFC057B1),
  sellCompany(AutomaDecisionItemType.action, 'SC', 'Sell Company', 0xFFFFAA55),
  sellToTheForeignMarket(AutomaDecisionItemType.action, 'SFM', 'Sell to the Foreign Market', 0xFFFF7074),
  fiscalPolicy(AutomaDecisionItemType.policy, '1', '1 - Fiscal Policy', 0xFF88AECE),
  laborMarket(AutomaDecisionItemType.policy, '2', '2 - Labor Market', 0xFFB5A4C6),
  taxation(AutomaDecisionItemType.policy, '3', '3 - Taxation', 0xFFDCA8CE),
  healthcare(AutomaDecisionItemType.policy, '4', '4 - Healthcare', 0xFFDC493F),
  education(AutomaDecisionItemType.policy, '5', '5 - Education', 0xFFD9884E),
  foreignTrade(AutomaDecisionItemType.policy, '6', '6 - Foreign Trade', 0xFFBDA692),
  immigration(AutomaDecisionItemType.policy, '7', '7 - Immigration', 0xFFAAA198);

  const AutomaDecisionItem(this.type, this.code, this.name, this.colorARGB);

  final AutomaDecisionItemType type;
  final String code;
  final String name;
  final int colorARGB;
}

enum AutomaDecisionItemType {
  action(1),
  policy(0);

  const AutomaDecisionItemType(this.minLevel);

  final int minLevel;
}
