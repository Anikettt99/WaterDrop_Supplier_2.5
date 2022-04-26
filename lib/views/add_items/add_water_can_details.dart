import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

import '../homepage/listed_items.dart';

class AddWaterCanDetails extends StatefulWidget {
  const AddWaterCanDetails({Key? key}) : super(key: key);

  @override
  _AddWaterCanDetailsState createState() => _AddWaterCanDetailsState();
}

class _AddWaterCanDetailsState extends State<AddWaterCanDetails> {
  bool isLoading = true;
  int normalWater = 1, chargesDependentOnFloor = 1;
  String brandNameDropDownValue = 'Bisleri';
  TextEditingController price = TextEditingController();
  TextEditingController fromFloor = TextEditingController();
  TextEditingController floorCharges = TextEditingController();
  TextEditingController otherBrandName = TextEditingController();
  bool brandNameChanged = false;
  TextEditingController stock = TextEditingController();
  bool itemQuantityChanged = false;
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  //var brandName = ['Bisleri', 'Kinley', 'Aquafina', 'Bailley', 'Himalayan', 'Bonaqua', 'Rail Neer', 'Other'];
  List<String> brandName = [];
  String itemQuantityDropDownValue = '10';
  var itemQuantity = ['5', '10', '15', '20', '25', '30'];
  bool loading = false;

  Widget askForFloorCharges() {
    return Column(
      children: [
        const Text(
          'Does your delivery charge depend on the floor number?',
          style: TextStyle(
              color: Color.fromRGBO(131, 131, 131, 1),
              fontSize: 16,
              letterSpacing: 0.5),
        ),
        Row(
          children: [
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              groupValue: chargesDependentOnFloor,
              value: 1,
              onChanged: (value) {
                setState(() {
                  chargesDependentOnFloor = 1;
                });
              },
              activeColor: primaryColor,
            ),
            const Text(
              'Yes',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 80,
            ),
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              groupValue: chargesDependentOnFloor,
              value: 0,
              onChanged: (value) {
                setState(() {
                  chargesDependentOnFloor = 0;
                });
              },
              activeColor: primaryColor,
            ),
            const Text(
              'No',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    dataBaseMethods.fetchBrandName().then((value) {
      print(value);
      setState(() {
        brandName = value;
        brandName.add("Other");
        isLoading = false;
      });
    });
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
          "Add Item Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: isLoading == true
          ? Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(child: CircularProgressIndicator()))
          : Stack(
              // alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ADD WATER CAN DETAILS',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.6,
                                child: const Text(
                                  'How many cans are available in your stock',
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1),
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                width: width * 0.2,
                                child: TextFormField(
                                  controller: stock,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 11),
                                    contentPadding: const EdgeInsets.all(15),
                                    labelText: "",
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    /*suffixIcon: Icon(
                                    Icons.check,
                                    color: secondaryColor,
                                  ),*/
                                  ),
                                  validator: (val) {
                                    if (val!.length == 0) {
                                      return 'Required';
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]+')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            items: brandName.map((String items) {
                              return DropdownMenuItem(
                                  value: items, child: Text(items));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                brandNameDropDownValue = newValue.toString();
                                brandNameChanged = true;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Select Brand Name",
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          brandNameDropDownValue == 'Other'
                              ? TextFormField(
                                  controller: otherBrandName,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    labelText: "Enter Brand Name",
                                    labelStyle: TextStyle(fontSize: 15),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z0-9 ]+')),
                                  ],
                                  validator: (val) {
                                    if (val!.length == 0 &&
                                        brandNameDropDownValue == 'Other') {
                                      return 'Required';
                                    }
                                  },
                                )
                              : Container(),
                          SizedBox(
                            height: brandNameDropDownValue == 'Other' ? 15 : 0,
                          ),
                          DropdownButtonFormField(
                            items: itemQuantity.map((String items) {
                              return DropdownMenuItem(
                                  value: items, child: Text(items));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                itemQuantityDropDownValue = newValue.toString();
                                itemQuantityChanged = true;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Item Quantity(L)",
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                groupValue: normalWater,
                                value: 1,
                                onChanged: (value) {
                                  setState(() {
                                    normalWater = 1;
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                              const Text(
                                'Normal water',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                groupValue: normalWater,
                                value: 0,
                                onChanged: (value) {
                                  setState(() {
                                    normalWater = 0;
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                              const Text(
                                'Chilled water',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: price,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Price",
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon: TextButton(
                                onPressed: () {},
                                child: Text(
                                  '₹  |',
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: height / 40),
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]+')),
                            ],
                            validator: (val) {
                              if (val!.length == 0) {
                                return 'Required';
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          askForFloorCharges(),
                          chargesDependentOnFloor == 1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('From',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                131, 131, 131, 1),
                                            fontSize: 17,
                                            letterSpacing: 0.5)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: width * 0.13,
                                      height: 25,
                                      child: TextFormField(
                                        controller: fromFloor,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                          isDense: false,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (name) {
                                          if (name!.isEmpty) {
                                            dataBaseMethods.showToastNotification(
                                                'Floor number cannot be empty');
                                            return null;
                                          }
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]+')),
                                          LengthLimitingTextInputFormatter(2)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text('floor ₹',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                131, 131, 131, 1),
                                            fontSize: 17,
                                            letterSpacing: 0.5)),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: width * 0.13,
                                      height: 25,
                                      child: TextFormField(
                                        controller: floorCharges,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                          isDense: false,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (name) {
                                          if (name!.isEmpty) {
                                            dataBaseMethods.showToastNotification(
                                                'Floor charges cannot be empty');
                                            return null;
                                          }
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]+')),
                                          LengthLimitingTextInputFormatter(3)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text('will increase.',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                131, 131, 131, 1),
                                            fontSize: 17,
                                            letterSpacing: 0.5)),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
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
                                  onPressed: loading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (!brandNameChanged) {
                                              dataBaseMethods
                                                  .showToastNotification(
                                                      'Select Brand Name');
                                            } else if (!itemQuantityChanged) {
                                              dataBaseMethods
                                                  .showToastNotification(
                                                      'Select Item Quantity');
                                            } else {
                                              String finalBrandName =
                                                  brandNameDropDownValue ==
                                                          'Other'
                                                      ? otherBrandName.text
                                                      : brandNameDropDownValue;
                                              if (int.parse(stock.text) == 0) {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'Stock cannot be zero');
                                                return;
                                              }
                                              if (int.parse(price.text) == 0) {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'Price cannot be zero');
                                                return;
                                              }
                                              Map<String, dynamic> itemDetails =
                                                  {
                                                'brandName': finalBrandName,
                                                'quantityAvailable': stock.text,
                                                'qtyInLiters':
                                                    itemQuantityDropDownValue,
                                                'unitPrice': price.text,
                                                'fromFloor':
                                                    fromFloor.text == null
                                                        ? '0'
                                                        : fromFloor.text,
                                                'isWaterChilled':
                                                    normalWater == 1
                                                        ? false
                                                        : true,
                                                'floorCharges':
                                                    floorCharges.text == null
                                                        ? '0'
                                                        : floorCharges.text,
                                                'isDispenser': false,
                                                'imageLink': '',
                                                'supplierId':
                                                    Constants.mySupplierId,
                                                'locationId':
                                                    Constants.myLocationId,
                                                'type': 'Water Can',
                                                'threshold': '1000',
                                                'floorDependentCharges':
                                                    chargesDependentOnFloor == 1
                                                        ? true
                                                        : false,
                                              };
                                              Map<String, dynamic>
                                                  newItemDetails = {};
                                              setState(() {
                                                loading = true;
                                              });
                                              await dataBaseMethods
                                                  .addItem(itemDetails)
                                                  .then((value) {
                                                newItemDetails = value;
                                              });
                                              setState(() {
                                                loading = false;
                                              });
                                              dataBaseMethods
                                                  .showToastNotification(
                                                      'Sucessfully Added Item');

                                              Navigator.pop(context);
                                              Navigator.pop(
                                                  context, newItemDetails);
                                            }
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
                        ],
                      ),
                    ),
                  ),
                ),
                loading
                    ? Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 3,
                          child: Container(
                            padding: EdgeInsets.all(12),
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
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
