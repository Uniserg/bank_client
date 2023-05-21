import 'package:json_annotation/json_annotation.dart';

part 'account_requisites.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountRequisites {
  final String number;
  final String bik;
  final String inn;
  final String kpp;
  final String correspondAccount;
  final String bankName;
  final bool active;

  AccountRequisites(
      {required this.number,
      required this.bik,
      required this.inn,
      required this.kpp,
      required this.correspondAccount,
      required this.bankName,
      required this.active});

  factory AccountRequisites.fromJson(Map<String, dynamic> json) =>
      _$AccountRequisitesFromJson(json);
}
