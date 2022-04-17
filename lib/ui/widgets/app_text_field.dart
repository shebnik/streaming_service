import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FieldType {
  email,
  password,
  name,
  age,
  phoneNumber,
  creditCardNumber,
  creditCardDueTo,
  creditCardCVV,
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    required this.controller,
    required this.fieldType,
    this.label,
    this.showError = false,
  }) : super(key: key);

  final TextEditingController controller;
  final FieldType fieldType;
  final String? label;
  final bool showError;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: widget.controller,
        keyboardType: getKeyboardType(),
        obscureText:
            widget.fieldType == FieldType.password ? _obscureText : false,
        inputFormatters: getInputFieldFormatters(),
        decoration: InputDecoration(
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: getHintText(),
          errorText: widget.showError ? "${widget.label} is wrong" : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          suffixIcon: getSuffixIcon(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  void onChanged(String value) {
    if (widget.fieldType == FieldType.creditCardNumber && value.endsWith(" ") ||
        widget.fieldType == FieldType.creditCardDueTo && value.endsWith("/")) {
      widget.controller.text = value.substring(0, value.length - 1);
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    }
  }

  List<TextInputFormatter> getInputFieldFormatters() {
    List<TextInputFormatter>? inputFormatters;
    switch (widget.fieldType) {
      case FieldType.email:
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9@.]')),
        ];
        break;
      case FieldType.password:
        break;
      case FieldType.name:
        inputFormatters = [LengthLimitingTextInputFormatter(32)];
        break;
      case FieldType.age:
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(3),
        ];
        break;
      case FieldType.phoneNumber:
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(15),
        ];
        break;
      case FieldType.creditCardNumber:
        inputFormatters = [
          LengthLimitingTextInputFormatter(19),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
          MaskedTextInputFormatter(mask: "0000 0000 0000 0000", separator: " "),
        ];
        break;
      case FieldType.creditCardDueTo:
        inputFormatters = [
          LengthLimitingTextInputFormatter(5),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9\/]')),
          MaskedTextInputFormatter(mask: "00/00", separator: "/"),
        ];
        break;
      case FieldType.creditCardCVV:
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(3),
        ];
        break;
    }
    return inputFormatters ?? [];
  }

  String? getHintText() {
    switch (widget.fieldType) {
      case FieldType.creditCardNumber:
        return "XXXX XXXX XXXX XXXX";
      case FieldType.creditCardDueTo:
        return "MM/YY";
      case FieldType.creditCardCVV:
        return "XXX";
      default:
        return null;
    }
  }

  Widget? getSuffixIcon() {
    switch (widget.fieldType) {
      case FieldType.password:
        return GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onTap: () {
            _obscureText = !_obscureText;
            setState(() {});
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
        );
      case FieldType.name:
        return const Icon(Icons.person);
      case FieldType.age:
        return const Icon(Icons.cake);
      case FieldType.phoneNumber:
        return const Icon(Icons.phone);
      case FieldType.creditCardNumber:
        return const Icon(Icons.credit_card);
      case FieldType.creditCardDueTo:
        return const Icon(Icons.calendar_month);
      case FieldType.creditCardCVV:
        return const Icon(Icons.security);
      default:
        return null;
    }
  }

  TextInputType? getKeyboardType() {
    return [
      FieldType.age,
      FieldType.creditCardNumber,
      FieldType.creditCardDueTo,
      FieldType.creditCardCVV,
      FieldType.phoneNumber,
    ].contains(widget.fieldType)
        ? TextInputType.number
        : null;
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}
