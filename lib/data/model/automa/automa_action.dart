import 'package:hegemon_companion/data/model/automa/automa_priority.dart';

class AutomaActionCheck {
  static const checkForeignMarket = AutomaActionCheck('Check Foreign Market',
      AutomaActionCheckStep([AutomaActionCheckItem.numberOfTransactions]), applyCheckForeignMarket);

  final String name;
  final AutomaActionCheckStep firstStep;
  final List<AutomaActionCheckAdjustPriority> Function(Map<String, dynamic>) applyCheck;

  const AutomaActionCheck(this.name, this.firstStep, this.applyCheck);

  static List<AutomaActionCheckAdjustPriority> applyCheckForeignMarket(Map<String, dynamic> responses) {
    var numberOfPossibleTransactions = responses['TX'];
    if (numberOfPossibleTransactions is int) {
      if (numberOfPossibleTransactions < 2) {
        return [AutomaActionCheckAdjustPriority(AutomaDecisionItem.specialAction, 1)];
      }
      else {
        return [AutomaActionCheckAdjustPriority(AutomaDecisionItem.sellToTheForeignMarket, numberOfPossibleTransactions)];
      }
    }
    else {
      return [];
    }
  }
}

class AutomaActionCheckAdjustPriority {
  final AutomaDecisionItem automaDecisionItem;
  final int levelChange;

  const AutomaActionCheckAdjustPriority(this.automaDecisionItem, this.levelChange);
}

class AutomaActionCheckStep {
  static const numberOfTransactions = AutomaActionCheckStep([AutomaActionCheckItem.numberOfTransactions]);
  final List<AutomaActionCheckItem> items;

  const AutomaActionCheckStep(this.items);
}

class AutomaActionCheckItem<T> {
  static const numberOfTransactions =
      AutomaActionCheckItem<int>('TX', 'Number of possible transactions', validateNumberOfTransactions, toIntValue);

  final String identifier;
  final String question;
  final String? Function(String?) validate;
  final T Function(String) toValue;

  const AutomaActionCheckItem(this.identifier, this.question, this.validate, this.toValue);

  static String? validateNumberOfTransactions(String? value) {
    var n = value == null ? -1 : int.tryParse(value) ?? -1;
    if (n < 0) {
      return 'Not a positive number';
    }
    if (n > 8) {
      return 'Too many transactions';
    }
    return null;
  }

  static int toIntValue(String s) {
    return int.tryParse(s) ?? 0;
  }
}
