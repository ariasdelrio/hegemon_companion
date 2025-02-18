import 'package:flutter/material.dart';
import 'package:hegemon_companion/view/automa_card/automa_card.dart';
import 'package:provider/provider.dart';

import 'view_model/automa_priority_view_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AutomaPriorityViewModel(), child: const HegemonCompanion()));
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
