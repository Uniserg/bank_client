import 'package:json_annotation/json_annotation.dart';

part 'registration_form.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegistrationForm {
  final String lastName;
  final String firstName;
  final String middleName;
  final String phoneNumber;
  final String passport;
  final String inn;
  final String email;
  final String login;
  final String password;

  const RegistrationForm(
      {required this.lastName,
      required this.firstName,
      required this.middleName,
      required this.phoneNumber,
      required this.passport,
      required this.inn,
      required this.email,
      required this.login,
      required this.password});

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RegistrationFormToJson(this);
}
