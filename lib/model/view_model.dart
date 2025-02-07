import 'package:flutter/material.dart';
import 'package:flutter_application_5/Hive/hive_instance_class.dart';
import 'package:flutter_application_5/model/category/category_model.dart';

import '../service/ApiService.dart';
import 'totalproduct/totalproduct_model.dart';

class ProductsViewProvider extends ChangeNotifier {
  List<CategoryForSale> products = [];

  List<TotalProduct> chechIsnotEmpty = HiveBoxes.totalPriceBox.values.toList();
  Future<List<CategoryForSale>> getAllProducts() async {
    products = await ProductService().cat();
    notifyListeners();
    return products;
  }

  num getTotlalPrice() {
    num price = 0;
    for (var element in HiveBoxes.totalPriceBox.values.toList()) {
      price = price + ((element.quantity ?? 0) * (element.price ?? 0));
    }
    return price;
  }
}
