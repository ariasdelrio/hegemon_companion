import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hegemon_companion/data/repository/automa/automa_priority_repository.dart';

import '../data/model/automa/automa_priority.dart';

class AutomaPriorityViewModel extends ChangeNotifier {
  final AutomaPriorityRepository _repository = AutomaPriorityRepository();
  var _hasUnsavedChanges = false;

  int get maxPriorityLevel {
    return _repository.currentPriority.maxLevel;
  }

  List<AutomaDecisionItem> getDecisionItems(AutomaDecisionItemType type, int level) {
    return _repository.currentPriority.getDecisionItems(type, level);
  }

  List<AutomaDecisionItem> getTopPriorities(AutomaDecisionItemType type, int maxItems) {
    return _getTopPrioritiesInt(type, maxItems, maxPriorityLevel);
  }

  List<AutomaDecisionItem> _getTopPrioritiesInt(AutomaDecisionItemType type, int maxItems, int maxLevel) {
    if (maxLevel == 0) {
      return [];
    }
    var items = getDecisionItems(type, maxLevel);
    if (items.length < maxItems) {
      items += _getTopPrioritiesInt(type, maxItems, maxLevel - 1);
    }
    return items.sublist(0, min(items.length, maxItems));
  }

  Future<void> updatePriority(AutomaDecisionItem automaDecisionItem, int newLevel) async {
    _repository.updatePriority(automaDecisionItem, newLevel);
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  Future<void> collapse() async {
    _repository.collapse();
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  bool hasUnsavedChanges() {
    return _hasUnsavedChanges;
  }

  void saveChanges() {
    _repository.saveChanges();
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  void dismissChanges() {
    _repository.dismissChanges();
    _hasUnsavedChanges = false;
    notifyListeners();
  }
}
