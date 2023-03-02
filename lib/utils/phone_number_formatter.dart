import 'package:flutter/services.dart';

class InternationalPhoneFormatter extends TextInputFormatter {
  String internationalPhoneFormat(value) {
    String nums = value.replaceAll(RegExp(r'[\D]'), '');
    String internationalPhoneFormatted = nums.length >= 1
        ? '+' +
            nums.substring(0, nums.length >= 1 ? 1 : null) +
            (nums.length > 1 ? ' (' : '') +
            nums.substring(1, nums.length >= 4 ? 4 : null) +
            (nums.length > 4 ? ') ' : '') +
            (nums.length > 4
                ? nums.substring(4, nums.length >= 7 ? 7 : null) +
                    (nums.length > 7
                        ? '-' + nums.substring(7, nums.length >= 11 ? 11 : null)
                        : '')
                : '')
        : nums;
    return internationalPhoneFormatted;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    return newValue.copyWith(
        text: internationalPhoneFormat(text),
        selection: new TextSelection.collapsed(
            offset: internationalPhoneFormat(text).length));
  }
}
