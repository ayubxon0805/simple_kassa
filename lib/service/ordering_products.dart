import 'package:flutter/material.dart';
import 'package:flutter_application_5/Hive/hive_instance_class.dart';
import 'package:flutter_application_5/model/category/category_model.dart';
import 'package:flutter_application_5/model/mainbox/mainbox_model.dart';
import 'package:flutter_application_5/model/view_model.dart';

import '../model/totalproduct/totalproduct_model.dart';

FocusNode myFocusNode = FocusNode();

List<TotalProduct> totalProduct = HiveBoxes.totalPriceBox.values.toList();

CategoryForSale catModel = CategoryForSale();
List<MainBoxModel> mainBox = <MainBoxModel>[];
TotalProduct sale = TotalProduct();
TotalProduct product = TotalProduct();
TotalProduct products = TotalProduct();

class OrderedSingelton {
  OrderedSingelton._();
  static Future<void> getAllProducts() async {
    List<CategoryForSale> ss = await ProductsViewProvider().getAllProducts();
    for (var iteam in ss) {
      if (iteam.barcode.toString() != '') {
        HiveBoxes.prefsBox.put(iteam.barcode.toString(), iteam);
      }
    }
  }

  static int getLastSku() {
    // Get the current maximum SKU from existing products
    int maxExistingSku = HiveBoxes.mainBox.values
        .map((product) => product.sku ?? 1000)
        .fold(1000, (max, sku) => sku > max ? sku : max);

    // Increment the maximum SKU to ensure uniqueness
    int newSku = maxExistingSku + 1;

    // Ensure the new SKU is always unique
    while (HiveBoxes.mainBox.values.any((product) => product.sku == newSku)) {
      newSku++;
    }

    return newSku;
  }

  static Future<bool> addProduct({
    required String name,
    required String barcode,
    required num productPrice,
    required int qcounter,
    required int sku,
  }) async {
    product = TotalProduct(
      name: name,
      barcode: barcode,
      quantity: 1,
      sku: sku,
      price: productPrice,
      category: "",
    );

    MainBoxModel? mm =
        HiveBoxes.mainBox.get(product.barcode, defaultValue: null);
    if (mm == null) {
      // Generate a new unique SKU for a new product
      product.sku = getLastSku();
    } else {
      // Use existing SKU for known products
      product.sku = mm.sku;
      product.quantity = 0;
      TotalProduct? checkedProduct =
          HiveBoxes.totalPriceBox.get(product.barcode, defaultValue: null);
      product.quantity = (checkedProduct?.quantity ?? 0) + 1;
    }

    return await HiveBoxes.totalPriceBox
        .put(product.barcode.toString(), product)
        .then((value) => true);
  }

  static bool addmyBox() {
    List<TotalProduct> totalproduct = HiveBoxes.totalPriceBox.values.toList();
    List<MainBoxModel> setToMainBox = [];
    // ignore: avoid_function_literals_in_foreach_calls
    totalproduct.forEach((element) {
      MainBoxModel mainBox = MainBoxModel(
        name: element.name,
        barcode: element.barcode,
        price: element.price,
        sku: element.sku,
        quantity: element.quantity,
      );
      setToMainBox.add(mainBox);
    });
    Map<dynamic, MainBoxModel> map = {};
    for (var m in setToMainBox) {
      map[m.key] = m;
    }
    HiveBoxes.mainBox.putAll(map);
    return true;
  }
}
