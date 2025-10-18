import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common.dart';

class CommonForm extends StatefulWidget {
  final void Function(String) submit;
  final List<CommonFormItem> items;

  const CommonForm({
    super.key,
    required this.submit,
    required this.items,
  });

  @override
  CommonFormState createState() {
    return CommonFormState();
  }
}

class CommonFormItem {
  final String question;
  final String? Function(String?) validator;

  const CommonFormItem(this.question, this.validator);
}

class CommonFormState extends State<CommonForm> {
  final _formKey = GlobalKey<FormState>();

  // TODO: support more items
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void button() {
    if (_formKey.currentState!.validate())
    {
      // TODO: support more items
      widget.submit(myController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                flex: 2,
                child: Text(
                  // TODO: support more items
                  widget.items[0].question,
                  style: TextStyle(color: Color(0xFFEAE8E9)),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: TextFormField(
                    style: TextStyle(color: Color(0xFFEAE8E9)),
                    cursorColor: Color(0xFFEAE8E9),
                    // TODO: support other types
                    keyboardType: TextInputType.number,
                    // TODO: support other types
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
                    ),
                    // TODO: support more items
                    validator: widget.items[0].validator,
                    // TODO: support more items
                    controller: myController,
                  )),
            ]),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: button,
                  child: Text('Done')),
            ),
          ],
        ),
      ),
    );
  }
}