import 'package:flutter/material.dart';
import 'package:hegemon_companion/data/model/automa/automa_priority.dart';

enum ActionCheck {
  companies('Companies'),
  foreignMarket('Foreign Market'),
  influence('Influence'),
  policies('Policies'),
  special('Special Action');

  const ActionCheck(this.name);

  final String name;
}

enum SpecialCheck {
  automation('Automation'),
  luxury('Luxury'),
  revenue('Revenue'),
  politicalPressure('Political Pressure');

  const SpecialCheck(this.name);

  final String name;
}

class PriorityChange {
  final AutomaDecisionItem automaDecisionItem;
  final int levelChange;

  const PriorityChange(this.automaDecisionItem, this.levelChange);
}

enum MarketCompaniesStatus {
  // producesNothing(Icons.shopping_cart_off),
  producesNothing(Icons.block),
  producesMoreOfSomething(Icons.shopping_cart),
  producesSomethingNew(Icons.add_shopping_cart);

  const MarketCompaniesStatus(this.icon);

  final IconData icon;
}

class ActionCheckService {
  static const int marketSize = 4;
  static const desiredPositions = {
    AutomaDecisionItem.fiscalPolicy: 3,
    AutomaDecisionItem.laborMarket: 3,
    AutomaDecisionItem.taxation: 3,
    AutomaDecisionItem.healthcare: 3,
    AutomaDecisionItem.education: 3,
    AutomaDecisionItem.foreignTrade: 1,
    AutomaDecisionItem.immigration: 3,
  };

  static List<PriorityChange> checkForeignMarket(int possibleForeignMarketTransactions) {
    if (possibleForeignMarketTransactions < 2) {
      return [PriorityChange(AutomaDecisionItem.specialAction, 1)];
    } else {
      return [PriorityChange(AutomaDecisionItem.sellToTheForeignMarket, possibleForeignMarketTransactions)];
    }
  }

  static List<PriorityChange> checkInfluence(bool billProposed, int influenceOtherPlayers, int influenceCC) {
    if (!billProposed || (influenceOtherPlayers <= influenceCC)) {
      return [PriorityChange(AutomaDecisionItem.specialAction, 1)];
    } else {
      return [PriorityChange(AutomaDecisionItem.lobby, influenceOtherPlayers - influenceCC)];
    }
  }

  static List<PriorityChange> checkCompanies(int productionPhasesRemaining,
      List<MarketCompaniesStatus> marketCompaniesStatus, bool demonstrationTakingPlace, List<int> sellValue) {
    int phasesOffset = productionPhasesRemaining ~/ 2;
    int bcAdjustment = 0;
    int saAdjustment = 0;
    int scAdjustment = 0;
    for (int i = 0; i < marketSize; i++) {
      if (marketCompaniesStatus[i] != MarketCompaniesStatus.producesNothing) {
        bcAdjustment += phasesOffset;
        if (marketCompaniesStatus[i] == MarketCompaniesStatus.producesSomethingNew) {
          bcAdjustment += 1;
        }
      }
    }
    if (demonstrationTakingPlace) {
      bcAdjustment += 3;
    }
    if (bcAdjustment <= 1) {
      saAdjustment = 1;
    }
    var x = sellValue.where((value) => value >= 20);
    if (x.isNotEmpty) {
      scAdjustment = x.map((value) => value ~/ 10).reduce((value, element) => (element >= 2) ? value + element : value);
    }
    List<PriorityChange> adjustments = [];
    if (bcAdjustment > 0) {
      adjustments.add(PriorityChange(AutomaDecisionItem.buildCompany, bcAdjustment));
    }
    if (saAdjustment > 0) {
      adjustments.add(PriorityChange(AutomaDecisionItem.specialAction, saAdjustment));
    }
    if (scAdjustment > 0) {
      adjustments.add(PriorityChange(AutomaDecisionItem.sellCompany, scAdjustment));
    }
    return adjustments;
  }

  static List<PriorityChange> checkPolicies(
      AutomaDecisionItem policy1, AutomaDecisionItem policy2, int policy1Position, int policy2Position) {
    List<PriorityChange> adjustments = [];
    int policy1Adjustment = _checkPolicy(policy1, policy1Position);
    int policy2Adjustment = _checkPolicy(policy2, policy2Position);
    if (policy1Adjustment > 0) {
      adjustments.add(PriorityChange(policy1, policy1Adjustment));
    }
    if (policy2Adjustment > 0) {
      adjustments.add(PriorityChange(policy2, policy2Adjustment));
    }
    int totalAdjustments = policy1Adjustment + policy2Adjustment;
    if (totalAdjustments > 0) {
      adjustments.add(PriorityChange(AutomaDecisionItem.proposeBill, totalAdjustments));
    } else {
      adjustments.add(PriorityChange(AutomaDecisionItem.specialAction, 1));
    }
    return adjustments;
  }

  static int _checkPolicy(AutomaDecisionItem policy, int policyPosition) {
    if (policyPosition == 0) {
      return 0;
    }
    var adjustment = (policyPosition - (desiredPositions[policy] ?? policyPosition)).abs();
    if (adjustment > 0 && policy == AutomaDecisionItem.taxation) {
      adjustment++;
    }
    return adjustment;
  }

  static List<PriorityChange> checkSpecialAutomation(int eligibleCompanies, int productionPhasesRemaining) {
    if (eligibleCompanies > 0) {
      return [PriorityChange(AutomaDecisionItem.specialAction, eligibleCompanies + (productionPhasesRemaining ~/ 2))];
    } else {
      return [];
    }
  }

  static List<PriorityChange> checkSpecialLuxury(int luxury, bool hasInfluence) {
    if (luxury > 3) {
      return [PriorityChange(AutomaDecisionItem.specialAction, luxury ~/ 3 + (hasInfluence ? 0 : 1))];
    } else {
      return [];
    }
  }

  static List<PriorityChange> checkSpecialRevenue(int revenue, int taxationPosition) {
    if (revenue >= 150) {
      int adjustment = revenue ~/ 100;
      if (taxationPosition == 1) {
        adjustment += 2;
      }
      if (taxationPosition == 2) {
        adjustment += 1;
      }
      return [PriorityChange(AutomaDecisionItem.specialAction, adjustment)];
    } else {
      return [];
    }
  }

  static List<PriorityChange> checkSpecialPoliticalPressure(
      int foreignTradePosition, int agriculturalCompanies, int luxuryCompanies) {
    int adjustment = 0;
    if (foreignTradePosition != 3) {
      adjustment += agriculturalCompanies;
    }
    if (foreignTradePosition != 2) {
      adjustment += luxuryCompanies;
    }
    if (adjustment > 0) {
      return [PriorityChange(AutomaDecisionItem.specialAction, adjustment)];
    } else {
      return [];
    }
  }
}
