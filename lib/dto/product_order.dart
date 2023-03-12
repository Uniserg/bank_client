import 'package:json_annotation/json_annotation.dart';

part 'product_order.g.dart';


enum ProductOrderStatus {
  CONFIRM_AWAIT,
  IN_PROGRESS,
  COMPLETED,
  REFUSED;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductOrder {
  int? id;
  String userSub;
  String productName;
  String address;
  DateTime? scheduledDate;
  DateTime? createdAt;
  ProductOrderStatus? status;

  ProductOrder({
    required this.userSub,
    required this.productName,
    required this.address,
    required this.scheduledDate,
    this.createdAt,
    this.status
  });

  Map<String, dynamic> toJson() => _$ProductOrderToJson(this);
  factory ProductOrder.fromJson(Map<String, dynamic> json) => _$ProductOrderFromJson(json);
}