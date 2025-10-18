import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/model/automa/automa_priority.dart';

final class Common {
  Common._();

  static const textColor = Color(0xFFEAE8E9);
  static const backgroundColor = Color(0xFF434141);
  static const textStyle = TextStyle(color: textColor);

  static const InputDecoration textInputDecoration = InputDecoration(
    border: UnderlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Common.textColor)),
  );

  // For the CC
  static const appBarColor = Color(0xFF0673BA);
  static const inactiveColor = Color(0xFF6A7686);

  static Color color(AutomaDecisionItem adi) {
    return Color(adi.colorARGB);
  }

  // Form

  static Widget label(String text) {
    return Text(text, style: textStyle);
  }

  static Widget formRow(String text, Widget inputWidget) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
        flex: 1,
        child: label(text),
      ),
      Flexible(flex: 1, child: inputWidget),
    ]);
  }

  static Widget numberSlider(int minValue, int maxValue, Color color, int initialValue, void Function(int) setValue) {
    return Slider(
        value: initialValue.toDouble(),
        label: initialValue.toString(),
        onChanged: (value) => setValue(value.toInt()),
        divisions: maxValue - minValue + 1,
        min: minValue.toDouble(),
        max: maxValue.toDouble(),
        activeColor: color);
  }

  static Widget segmentedButton(List<String> options, String initialValue, void Function(String) setValue) {
    return SegmentedButton<String>(
        segments: options.map((option) => ButtonSegment<String>(value: option, label: Text(option))).toList(),
        selected: {initialValue},
        showSelectedIcon: false,
        onSelectionChanged: (Set<String> newSelection) {
          setValue(newSelection.first);
        });
  }

  static Widget checkbox(Color color, bool initialValue, void Function(bool) setValue) {
    return Checkbox(
        side: BorderSide(color: textColor),
        activeColor: color,
        value: initialValue,
        onChanged: (value) => setValue(value ?? false));
  }

  static Widget numberField(int? initialValue, void Function(int) setValue) {
    return TextFormField(
      style: textStyle,
      cursorColor: textColor,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
      ),
      initialValue: initialValue?.toString(),
      onChanged: (value) => setValue(int.tryParse(value) ?? 0),
    );
  }
}

class HCText extends StatelessWidget {
  final String text;

  const HCText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Common.textStyle);
  }
}

class HCNumberInput extends StatelessWidget {
  final TextEditingController controller;

  const HCNumberInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Common.textStyle,
      cursorColor: Common.textColor,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      decoration: Common.textInputDecoration,
      autofocus: true,
      controller: controller,
    );
  }
}
