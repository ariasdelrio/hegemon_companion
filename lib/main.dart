import 'package:flutter/material.dart';
import 'package:hegemon_companion/view/automa/card_builder.dart';
import 'package:hegemon_companion/view_model/automa_card_vm.dart';
import 'package:provider/provider.dart';

import 'view_model/automa_priority_vm.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AutomaPriorityViewModel()),
      ChangeNotifierProvider(create: (_) => AutomaCardViewModel()),
    ], child: const HegemonCompanion()),
  );
}

class HegemonCompanion extends StatelessWidget {
  const HegemonCompanion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hegemon Companion',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: CardBuilder(),
      // home: CheckActionForm(),
    );
  }
}
