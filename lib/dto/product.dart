import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class Product {
  String name;
  double rate;
  List<int>? logo;
  String description;
  int period;

  Product({
    required this.name,
    required this.rate,
    required this.logo,
    required this.description,
    required this.period});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}