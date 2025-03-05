import 'package:flutter/material.dart';
import 'package:flutter_application_5/Hive/hive_class.dart';
import 'package:flutter_application_5/Hive/hive_instance_class.dart';
import 'package:flutter_application_5/bloc/cardsifatidaq/addptocard_bloc.dart';
import 'package:flutter_application_5/bloc/getData/getdata_bloc.dart';
import 'package:flutter_application_5/bloc/yangi%20qoshuvch/add_product_bloc.dart';
import 'package:flutter_application_5/model/view_model.dart';
import 'package:flutter_application_5/ui/left_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await HiveBoxes.lastSku.put("detectSku", 1000);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) {
        return ProductsViewProvider();
      },
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddProductBloc()),
        BlocProvider(create: (context) => AddptocardBloc()),
        BlocProvider(create: (context) => GetdataBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyWidget(),
      ),
    );
  }
}
/// flutter packages pub run build_run build 
/// /// flutter packages pub run build_runner build --delete-conflicting-outputs