import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/model/automa/automa_action.dart';
import '../data/model/automa/automa_priority.dart';

class AutomaCardViewModel extends ChangeNotifier {
  static const int maxNumberOfCompanies = 12;
  static const policyPositionOptions = ['A', 'B', 'C', 'X'];
  static const _policyPositionValues = {'X': 0, 'A': 1, 'B': 2, 'C': 3};

  ActionCheck _actionCheck = ActionCheck.companies;
  AutomaDecisionItem _policy1 = AutomaDecisionItem.taxation;
  AutomaDecisionItem _policy2 = AutomaDecisionItem.education;
  SpecialCheck _specialCheck = SpecialCheck.automation;
  int _possibleForeignMarketTransactions = 0;
  bool _billProposed = false;
  int _influenceOtherPlayers = 0;
  int _influenceCC = 0;
  final List<MarketCompaniesStatus> _marketCompaniesStatus = List.filled(
      ActionCheckService.marketSize, MarketCompaniesStatus.producesNothing);
  bool _demonstrationTakingPlace = false;
  final List<int> _sellValue = [];
  int _productionPhasesRemaining = 0;
  String _policy1position = 'X';
  String _policy2position = 'X';
  int _eligibleCompanies = 0;
  int _luxury = 0;
  bool _hasInfluence = true;
  int _revenue = 0;
  String _taxationPosition = 'C';
  String _foreignTradePosition = 'A';
  int _agriculturalCompanies = 0;
  int _luxuryCompanies = 0;

  ActionCheck get actionCheck => _actionCheck;

  AutomaDecisionItem get policy1 => _policy1;

  AutomaDecisionItem get policy2 => _policy2;

  SpecialCheck get specialCheck => _specialCheck;

  int get possibleForeignMarketTransactions => _possibleForeignMarketTransactions;

  bool get billProposed => _billProposed;

  int get influenceOtherPlayers => _influenceOtherPlayers;

  int get influenceCC => _influenceCC;

  MarketCompaniesStatus getMarketCompaniesStatus(int index) =>
      index < 0 || index >= ActionCheckService.marketSize
          ? MarketCompaniesStatus.producesNothing
          : _marketCompaniesStatus[index];

  bool get demonstrationTakingPlace => _demonstrationTakingPlace;

  int getSellValue(int index) => index < 0 || index >= _sellValue.length ? 0 : _sellValue[index];

  int get productionPhasesRemaining => _productionPhasesRemaining;

  String get policy1Position => _policy1position;

  String get policy2Position => _policy2position;

  int get eligibleCompanies => _eligibleCompanies;

  int get luxury => _luxury;

  bool get hasInfluence => _hasInfluence;

  int get revenue => _revenue;

  String get taxationPosition => _taxationPosition;

  String get foreignTradePosition => _foreignTradePosition;

  int get agriculturalCompanies => _agriculturalCompanies;

  int get luxuryCompanies => _luxuryCompanies;

  int get numberOfNonOperationalCompanies => _sellValue.length;

  void setActionCheck(ActionCheck value) {
    _actionCheck = value;
    notifyListeners();
  }

  void setPolicies(AutomaDecisionItem value1, AutomaDecisionItem value2) {
    if (AutomaDecisionItem.values.indexOf(value1) < AutomaDecisionItem.values.indexOf(value2)) {
      _policy1 = value1;
      _policy2 = value2;
    }
    else {
      _policy2 = value1;
      _policy1 = value2;
    }
    notifyListeners();
  }

  void setSpecialCheck(SpecialCheck value) {
    _specialCheck = value;
    notifyListeners();
  }

  void setPossibleForeignMarketTransactions(int value) {
    _possibleForeignMarketTransactions = value;
    notifyListeners();
  }

  void setBillProposed(bool value) {
    _billProposed = value;
    notifyListeners();
  }

  void setInfluenceOtherPlayers(int value) {
    _influenceOtherPlayers = value;
    notifyListeners();
  }

  void setInfluenceCC(int value) {
    _influenceCC = value;
    notifyListeners();
  }

  void setMarketCompaniesStatus(int index, MarketCompaniesStatus value) {
    if (index >= 0 && index < ActionCheckService.marketSize) {
      _marketCompaniesStatus[index] = value;
      notifyListeners();
    }
  }

  void setDemonstrationTakingPlace(bool value) {
    _demonstrationTakingPlace = value;
    notifyListeners();
  }

  void setSellValue(int index, int value) {
    if (index < maxNumberOfCompanies) {
      _sellValue[index] = value;
      notifyListeners();
    }
  }

  void setProductionPhasesRemaining(int value) {
    _productionPhasesRemaining = value;
    notifyListeners();
  }

  void setPolicy1(AutomaDecisionItem value) {
    _policy1 = value;
    notifyListeners();
  }

  void setPolicy2(AutomaDecisionItem value) {
    _policy2 = value;
    notifyListeners();
  }

  void setPolicy1Position(String value) {
    _policy1position = value;
    notifyListeners();
  }

  void setPolicy2Position(String value) {
    _policy2position = value;
    notifyListeners();
  }

  void setEligibleCompanies(int value) {
    _eligibleCompanies = value;
    notifyListeners();
  }

  void setLuxury(int value) {
    _luxury = value;
    notifyListeners();
  }

  void setHasInfluence(bool value) {
    _hasInfluence = value;
    notifyListeners();
  }

  void setRevenue(int value) {
    _revenue = value;
    notifyListeners();
  }

  void setTaxationPosition(String value) {
    _taxationPosition = value;
    notifyListeners();
  }

  void setForeignTradePosition(String value) {
    _foreignTradePosition = value;
    notifyListeners();
  }

  void setAgriculturalCompanies(int value) {
    _agriculturalCompanies = value;
    notifyListeners();
  }

  void setLuxuryCompanies(int value) {
    _luxuryCompanies = value;
    notifyListeners();
  }

  void removeNonOperationalCompanyAt(int index) {
    if (index >= 0 && index < _sellValue.length) {
      _sellValue.removeAt(index);
    }
    notifyListeners();
  }

  void addNonOperationalCompany(int sellValue) {
    if (_sellValue.length < maxNumberOfCompanies) {
      _sellValue.add(sellValue);
    }
    notifyListeners();
  }

  List<PriorityChange> getPriorityAdjustments() {
    switch (actionCheck) {
      case ActionCheck.foreignMarket:
        return ActionCheckService.checkForeignMarket(possibleForeignMarketTransactions);
      case ActionCheck.influence:
        return ActionCheckService.checkInfluence(billProposed, influenceOtherPlayers, influenceCC);
      case ActionCheck.companies:
        return ActionCheckService.checkCompanies(
            productionPhasesRemaining,
            _marketCompaniesStatus,
            demonstrationTakingPlace,
            _sellValue);
      case ActionCheck.policies:
        return ActionCheckService.checkPolicies(
            policy1, policy2, _policyPositionValues[policy1Position] ?? 0, _policyPositionValues[policy2Position] ?? 0);
      case ActionCheck.special:
        switch (specialCheck) {
          case SpecialCheck.automation:
            return ActionCheckService.checkSpecialAutomation(eligibleCompanies, productionPhasesRemaining);
          case SpecialCheck.luxury:
            return ActionCheckService.checkSpecialLuxury(luxury, hasInfluence);
          case SpecialCheck.revenue:
            return ActionCheckService.checkSpecialRevenue(revenue, _policyPositionValues[taxationPosition] ?? 0);
          case SpecialCheck.politicalPressure:
            return ActionCheckService.checkSpecialPoliticalPressure(
                _policyPositionValues[foreignTradePosition] ?? 0, agriculturalCompanies, luxuryCompanies);
        }
    }
  }
}
