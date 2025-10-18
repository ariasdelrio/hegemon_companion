import 'package:flutter/foundation.dart';

import '../data/model/automa/automa_action.dart';

class AutomaActionViewModel extends ChangeNotifier {

  AutomaActionCheckStep getNextStep() {
    return AutomaActionCheckStep.numberOfTransactions;
  }
}