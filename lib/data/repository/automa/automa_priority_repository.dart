import 'package:hegemon_companion/data/model/automa/automa_priority.dart';

class AutomaPriorityRepository {
  static final AutomaPriorityRepository _instance = AutomaPriorityRepository._();
  static final AutomaPriority initialPriority = AutomaPriority([
    AutomaPriorityItem(AutomaDecisionItem.specialAction, 1),
    AutomaPriorityItem(AutomaDecisionItem.lobby, 1),
    AutomaPriorityItem(AutomaDecisionItem.sellCompany, 1),
    AutomaPriorityItem(AutomaDecisionItem.laborMarket, 1),
    AutomaPriorityItem(AutomaDecisionItem.healthcare, 1),
    AutomaPriorityItem(AutomaDecisionItem.foreignTrade, 1),
    AutomaPriorityItem(AutomaDecisionItem.immigration, 1),
    AutomaPriorityItem(AutomaDecisionItem.buildCompany, 2),
    AutomaPriorityItem(AutomaDecisionItem.sellToTheForeignMarket, 2),
    AutomaPriorityItem(AutomaDecisionItem.proposeBill, 2),
    AutomaPriorityItem(AutomaDecisionItem.taxation, 2),
    AutomaPriorityItem(AutomaDecisionItem.fiscalPolicy, 0),
    AutomaPriorityItem(AutomaDecisionItem.education, 0),
  ]);

  AutomaPriority _automaPriority;
  AutomaPriority _currentPriority;

  AutomaPriorityRepository._()
      : _automaPriority = initialPriority,
        _currentPriority = initialPriority;

  factory AutomaPriorityRepository() {
    return _instance;
  }

  AutomaPriority get currentPriority {
    return _currentPriority;
  }

  void updatePriority(AutomaDecisionItem decisionItem, int newLevel) {
    _currentPriority = _currentPriority.adjustItemPriority(decisionItem, (_) => newLevel);
  }

  void collapse() {
    _currentPriority = _currentPriority.collapse();
  }

  void saveChanges() {
    _automaPriority = _currentPriority;
  }

  void dismissChanges() {
    _currentPriority = _automaPriority;
  }
}
