import 'package:flutter/material.dart';
import 'package:hegemon_companion/view/automa_card/automa_card.dart';
import 'package:hegemon_companion/view_model/automa_action_view_model.dart';
import 'package:provider/provider.dart';

import 'view_model/automa_priority_view_model.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AutomaPriorityViewModel()),
      ChangeNotifierProvider(create: (_) => AutomaActionViewModel())
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
      home: AutomaCard(),
    );
  }
}
