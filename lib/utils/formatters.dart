import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneNumberFormatter = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'\d')},
    type: MaskAutoCompletionType.lazy);

final nameFormatter = TextInputFormatter.withFunction(
  (TextEditingValue oldValue, TextEditingValue newValue) {
    return RegExp(r'[^А-Яа-я]').hasMatch(newValue.text) ? newValue : oldValue;
  },
);
