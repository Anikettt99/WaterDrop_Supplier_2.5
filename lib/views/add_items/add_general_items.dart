import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'dart:math' as math;

class AddGeneralItems extends StatefulWidget {
  const AddGeneralItems({Key? key}) : super(key: key);

  @override
  _AddGeneralItemsState createState() => _AddGeneralItemsState();
}

class _AddGeneralItemsState extends State<AddGeneralItems> {
  HelperFunctions helperFunctions = HelperFunctions();
  TextEditingController price = TextEditingController();
  TextEditingController brandName = TextEditingController();
  TextEditingController totalQuantity = TextEditingController();
  TextEditingController qtyInLiters = TextEditingController();
  TextEditingController category = TextEditingController();
  /*TextEditingController fromFloor = TextEditingController();
  TextEditingController floorCharges = TextEditingController();*/
  bool brandNameChanged = false;
  bool itemQuantityChanged = false;
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = false;
  var itemQuantityInMl = ['0', '250', '300', '350', '500', '750'];
  String itemQuantityDropDownValue = '0';
  var unitDropDown = ['L', 'ml'];
  String unitDropDownValue = 'L';

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back),
            color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Add Item Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD DETAILS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: brandName,
                    decoration: InputDecoration(

                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Product Name",
                      labelStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]+')),
                    ],
                    validator: (name) {
                      if (name!.length == 0) {
                        return 'Required';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: TextFormField(
                          controller: qtyInLiters,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Item Quantity",
                            labelStyle: TextStyle(fontSize: 14.5),
                            border: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2),
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]+'))
                           // WhitelistingTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          validator: (name) {
                            if (name!.length == 0) {
                              return 'Required';
                            }
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 50,
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: unitDropDownValue,
                            items: unitDropDown.map((String items) {
                              return DropdownMenuItem(value: items, child: Text(items));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                itemQuantityChanged = true;
                                unitDropDownValue = newValue.toString();
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 0),
                              labelText: "Unit",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: category,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Category",
                      labelStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val){
                      if (val!.length == 0) {
                        return 'Required';
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: totalQuantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "No of items available in your stock",
                      labelStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                    ],
                    validator: (val){
                      if (val!.length == 0) {
                        return 'Required';
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: price,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: TextButton(
                        onPressed: () {},
                        child: Text(
                          '₹  |',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: height / 40),
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                    ],
                    validator: (val){
                      if (val!.length == 0) {
                        return 'Required';
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
          loading ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 3,
            child: Container(
              padding: EdgeInsets.all(13),
              width: width * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  const Text(
                    'Adding Item',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          ) : Container()
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width / 3,
              height: height / 15,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    "GO BACK",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: width / 23,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width / 3,
              height: height / 15,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                color: primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: FlatButton(
                onPressed: loading ? null : () async {
                  if(_formKey.currentState!.validate()) {
                    print(qtyInLiters.text);
                    if(int.parse(totalQuantity.text) == 0){
                      dataBaseMethods.showToastNotification('Stock cannot be zero');
                      return;
                    }
                    try {
                      if (qtyInLiters.text == '0.00' || qtyInLiters.text == '0.0' || double.parse(qtyInLiters.text) == 0) {
                        dataBaseMethods.showToastNotification(
                            'Item quantity cannot be zero');
                        return;
                      }
                    }
                    catch(e){
                      print(e);
                      dataBaseMethods.showToastNotification(
                          'Invalid Item Quantity');
                      return;
                      return;
                    }
                    if(int.parse(price.text) == 0){
                      dataBaseMethods.showToastNotification('Price cannot be zero');
                      return;
                    }
                    //String finalItemQty = helperFunctions.fetchItemQuantityInLiters(qtyInLiters.text, itemQuantityDropDownValue);
                    String finalItemQty = qtyInLiters.text + unitDropDownValue;
                    print(finalItemQty);
                      Map<String, dynamic> itemDetails = {
                        'brandName': brandName.text,
                        'quantityAvailable': totalQuantity.text,
                        'qtyInLiters': finalItemQty,
                        'unitPrice': price.text,
                        'isDispenser': false,
                        'imageLink': '',
                        'supplierId': Constants.mySupplierId,
                        'locationId': Constants.myLocationId,
                        'type': category.text,
                        'threshold' : '1000',
                        'isWaterChilled': false,
                        'isInPack': false,
                        'isGeneralProduct': true,
                      };
                      Map<String, dynamic> newItemDetails = {};
                      setState(() {
                        loading = true;
                      });
                      await dataBaseMethods.addItem(itemDetails).then((value) {
                        newItemDetails = value;
                      });
                      setState(() {
                        loading = false;
                      });
                      dataBaseMethods.showToastNotification('Sucessfully Added Item');
                      Navigator.pop(context);
                      Navigator.pop(context, newItemDetails);
                    }
                },
                child: Center(
                  child: Text(
                    "ADD ITEM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width / 23,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
