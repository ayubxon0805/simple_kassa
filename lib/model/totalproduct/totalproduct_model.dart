import 'package:flutter_application_5/Hive/adapters.dart';
import 'package:hive/hive.dart';
part 'totalproduct_model.g.dart';

@HiveType(typeId: 2, adapterName: Adapters.productAdapter)
class TotalProduct extends HiveObject {
  @override
  get key => barcode;
  @HiveField(0)
  String? name;
  @HiveField(1)
  int? quantity;
  @HiveField(2)
  num? price;
  @HiveField(3)
  String? barcode;
  @HiveField(4)
  String? category;
  @HiveField(5)
  int? sku;
  TotalProduct(
      {this.name,
      this.quantity,
      this.price,
      this.barcode,
      this.category,
      this.sku});

  TotalProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'] ?? 1;
    price = json['price'] ?? 1;
    barcode = json['barcode'].toString();
    category = json['category'] ?? 'each';
    sku = json['sku'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['totalname'] = name;
    data['totalquantity'] = quantity;
    data['totalprice'] = price;
    data['barcode'] = barcode;
    data['barcode'] = category;
    data['barcode'] = sku;

    return data;
  }
}
