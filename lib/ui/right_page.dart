// ignore_for_file: unused_local_variable, avoid_function_literals_in_foreach_calls, sized_box_for_whitespace, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_application_5/Hive/hive_instance_class.dart';
import 'package:flutter_application_5/bloc/cardsifatidaq/addptocard_bloc.dart';
import 'package:flutter_application_5/bloc/yangi%20qoshuvch/add_product_bloc.dart';
import 'package:flutter_application_5/model/category/category_model.dart';
import 'package:flutter_application_5/model/mainbox/mainbox_model.dart';
import 'package:flutter_application_5/model/totalproduct/totalproduct_model.dart';
import 'package:flutter_application_5/model/view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RightPage extends StatefulWidget {
  const RightPage({super.key});

  @override
  State<RightPage> createState() => _RightPageState();
}

class _RightPageState extends State<RightPage> {
  TextEditingController barcode = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  int counter = 1000;
  num totalP = 0;
  int qcounter = 1;
  List<TotalProduct> allPrice = [];
  FocusNode myFocusNode = FocusNode();
  CategoryForSale? catModel = CategoryForSale();
  List<CategoryForSale> categoryproduct =
      HiveBoxes.prefsBox.values.toList().cast();
  List<TotalProduct> totalProduct = HiveBoxes.totalPriceBox.values.toList();

  List<MainBoxModel> mainBox = HiveBoxes.mainBox.values.toList();

  void _calculateTotalPrice() {
    totalP = totalProduct.fold(
        0,
        (sum, product) =>
            sum + ((product.quantity ?? 0) * (product.price ?? 0)));
  }

  void _clearAllProducts() {
    if (totalProduct.isNotEmpty) {
      totalProduct.clear();
      HiveBoxes.totalPriceBox.clear();
      totalP = 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;

    return Container(
      height: MediaQuery.of(context).size.height * 0.87,
      width: MediaQuery.of(context).size.width * 0.52,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Productable(
              sku: 'Sku',
              name: 'Name',
              price: 'Price',
              quantity: 'Quantity',
              totalPrice: 'TotalPrice'),
          BlocConsumer<AddProductBloc, AddProductState>(
              listener: (context, state) {
            if (state is AddedProductsSuccesState) {
              totalProduct = HiveBoxes.totalPriceBox.values.toList();
              isSelected = true;
              _calculateTotalPrice();
            }
          }, builder: (context, state) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.60,
                child: SingleChildScrollView(
                    child: Column(children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: totalProduct.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    title: Text(
                                      'Edit Product Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo.shade700,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: productPrice,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'New Price',
                                            prefixIcon: Icon(Icons.price_change,
                                                color: Colors.indigo.shade700),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.indigo.shade700,
                                                  width: 2),
                                            ),
                                          ),
                                          style: TextStyle(fontSize: 16),
                                          onSubmitted: (value) {
                                            if (value.isNotEmpty) {
                                              BlocProvider.of<AddptocardBloc>(
                                                      context)
                                                  .add(AddPtoCardEvent());
                                              totalProduct[index].price =
                                                  int.parse(productPrice.text);
                                              productPrice.text = '';
                                              barcode.clear();
                                              myFocusNode.requestFocus();
                                              _calculateTotalPrice();
                                              setState(() {});
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.indigo.shade700,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (productPrice.text.isNotEmpty) {
                                              BlocProvider.of<AddptocardBloc>(
                                                      context)
                                                  .add(AddPtoCardEvent());
                                              totalProduct[index].price =
                                                  int.parse(productPrice.text);
                                              productPrice.text = '';
                                              barcode.clear();
                                              myFocusNode.requestFocus();
                                              _calculateTotalPrice();
                                              setState(() {});
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text('Update Price',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: table(
                              sku: totalProduct[index].sku.toString(),
                              name: totalProduct[index].name.toString(),
                              price: totalProduct[index].price.toString(),
                              quantity: totalProduct[index].quantity.toString(),
                              totalPrice:
                                  '${(totalProduct[index].price ?? 0) * (totalProduct[index].quantity ?? 0)}',
                            ));
                      })
                ])));
          }),
          BlocConsumer<AddProductBloc, AddProductState>(
            listener: (context, state) {
              if (state is AddedProductsSuccesState) {
                _calculateTotalPrice();
              }
            },
            builder: (context, state) {
              return Consumer<ProductsViewProvider>(
                  builder: (context, value, child) {
                if (ProductsViewProvider().chechIsnotEmpty.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 180,
                      color: const Color.fromARGB(255, 17, 30, 63),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Total Price',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.12),
                                  Container(
                                    width: 200,
                                    height: 30,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            totalP.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22),
                                          ),
                                          // })
                                        ]),
                                  ),
                                  const SizedBox(width: 15),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                backgroundColor: Colors.indigo.shade700,
                                minimumSize: const Size(160, 160)),
                            onPressed: () {
                              if (totalProduct.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Confirm Sale',
                                        style: TextStyle(
                                            color: Colors.indigo.shade700)),
                                    content: Text('Total sale amount: $totalP'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.indigo.shade700),
                                        onPressed: () {
                                          // Implement sale logic here
                                          _clearAllProducts();
                                          Navigator.pop(context);
                                        },
                                        child: Text('Confirm Sale'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No products to sell'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Sell',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text('');
                }
              });
            },
          )
        ],
      ),
    );
  }

  Widget table(
      {required String sku,
      required String name,
      required String price,
      required String quantity,
      required String totalPrice}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: Container(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      sku,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 60,
                child: Container(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 25,
                child: Container(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      price.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 25,
                child: Container(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 40,
                child: Container(
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      totalPrice.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Productable(
      {required String name,
      required String price,
      required String quantity,
      required String totalPrice,
      required String sku}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                          color: Color.fromARGB(255, 17, 30, 63),
                          width: 3,
                        ),
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    sku.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 60,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                          color: Color.fromARGB(255, 17, 30, 63),
                          width: 3,
                        ),
                        right: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3),
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 25,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3),
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    price.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 25,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3),
                        bottom: BorderSide(
                            color: Color.fromARGB(255, 17, 30, 63), width: 3))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 40,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(
                          color: Color.fromARGB(255, 17, 30, 63),
                          width: 3,
                        ),
                        bottom: BorderSide(
                            color: Color.fromARGB(
                              255,
                              17,
                              30,
                              63,
                            ),
                            width: 3))),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    totalPrice.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
