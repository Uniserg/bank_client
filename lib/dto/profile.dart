import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Profile {
  final String sub;
  final String? email;
  final String? lastName;
  final String firstName;
  final List<int>? avatar;

  Profile(
      {required this.sub,
      required this.firstName,
      this.email,
      this.lastName,
      this.avatar});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
