import 'package:flutter_application_5/Hive/hive_instance_class.dart';
import 'package:flutter_application_5/model/category/category_model.dart';
import 'package:flutter_application_5/model/mainbox/mainbox_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as pp;
import '../model/totalproduct/totalproduct_model.dart';

@lazySingleton
class HiveService {
  const HiveService._();
  static Future<void> init() async {
    final dir = await pp.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(CategorysForSaleAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(MainBoxModelAdapter());
    await Hive.openBox<CategoryForSale>(HiveBoxNames.openedOrder);
    await Hive.openBox<TotalProduct>(HiveBoxNames.productTotal);
    await Hive.openBox<MainBoxModel>(HiveBoxNames.mainbox);
    await Hive.openBox<int>(HiveBoxNames.lastSku);
  }
}
