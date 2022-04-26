import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';
import 'dart:math' as math;
import '../../helper/helper.dart';

class EditGeneralItems extends StatefulWidget {
  Map<String, dynamic> details;
  EditGeneralItems({Key? key, required this.details}) : super(key: key);

  @override
  _EditGeneralItemsState createState() => _EditGeneralItemsState();
}

class _EditGeneralItemsState extends State<EditGeneralItems> {
  /*TextEditingController fromFloor = TextEditingController();
  TextEditingController floorCharges = TextEditingController();*/
  bool brandNameChanged = false;
  bool itemQuantityChanged = false;
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Map<String, dynamic> details = {};
  bool loading = false;
  var itemQuantityInMl = ['0', '250', '300', '350', '500', '750'];
  String itemQuantityDropDownValue = '0';
  HelperFunctions helperFunctions = HelperFunctions();
  String literPart = '', quantity = '';
  var unitDropDown = ['L', 'ml'];
  String unitDropDownValue = 'L';

  @override
  void initState() {
    details = widget.details;
    var value = helperFunctions.segregateGeneralItemQuantity(details['qtyInLiters']);
    itemQuantityDropDownValue = helperFunctions.fetchItemQuantity(details['qtyInLiters']);
    unitDropDownValue = helperFunctions.fetchItemQuantityUnit(details['qtyInLiters']);
    quantity = helperFunctions.fetchItemQuantity(details['qtyInLiters']);
    // TODO: implement initState
    super.initState();
  }

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
          "Edit Item Details",
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
                    'EDIT DETAILS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: details['brandName'],
                    //controller: brandName,
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
                    onSaved: (val){
                      details['brandName'] = val;
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
                          initialValue: quantity,
                          //controller: qtyInLiters,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Item Quantity",
                            border: OutlineInputBorder(
                              borderSide:
                              const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2),
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]+')),
                          ],
                          validator: (name) {
                            if (name!.length == 0) {
                              return 'Required';
                            }
                          },
                          onSaved: (val){
                            quantity = val!;
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        height: 50,
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value:  unitDropDownValue,
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
                    initialValue: details['type'],
                    //controller: category,
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
                    onSaved: (val){
                      details['type'] = val;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    initialValue: details['quantityAvailable'].toString(),
                    //controller: totalQuantity,
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
                    validator: (val){
                      if (val!.length == 0) {
                        return 'Required';
                      }
                      if(int.parse(val) == 0){
                        return 'Stock cannot be zero';
                      }
                    },
                    onSaved: (val){
                      details['quantityAvailable'] = val;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    initialValue: details['unitPrice'].toString(),
                    keyboardType: TextInputType.number,
                  //  controller: price,
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
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+'))
                    ],
                    validator: (val){
                      if (val!.length == 0) {
                        return 'Required';
                      }
                      if(int.parse(val) == 0){
                        return 'Price cannot be zero';
                      }
                    },
                    onSaved: (val){
                      details['unitPrice'] = val;
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
                    'Editing Item',
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
                      fontSize: 18,
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
                    _formKey.currentState!.save();
                    String finalItemQty = quantity + unitDropDownValue;
                    details['qtyInLiters'] = finalItemQty;
                    print(details['qtyInLiters']);
                    if(int.parse(details['quantityAvailable']) == 0){
                      dataBaseMethods.showToastNotification('Stock cannot be zero');
                      return;
                    }
                    try {
                      if (double.parse(quantity) == 0) {
                        dataBaseMethods.showToastNotification(
                            'Item quantity cannot be zero');
                        return;
                      }
                    }
                    catch(e){
                      dataBaseMethods.showToastNotification(
                          'Invalid item quantity');
                      return;
                    }
                    if(int.parse(details['unitPrice']) == 0){
                      dataBaseMethods.showToastNotification('Price cannot be zero');
                      return;
                    }
                    setState(() {
                      loading = true;
                    });
                    await dataBaseMethods.editItemDetails(details['_id'], details);
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  HomePage(index: 0,)));
                  }
                },
                child: const Center(
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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

