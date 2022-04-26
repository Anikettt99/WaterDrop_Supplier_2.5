// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

class AddWaterBottleDetails extends StatefulWidget {
  const AddWaterBottleDetails({Key? key}) : super(key: key);

  @override
  _AddWaterBottleDetailsState createState() => _AddWaterBottleDetailsState();
}

class _AddWaterBottleDetailsState extends State<AddWaterBottleDetails> {
  bool isLoading = true;
  int availableToPack = 1;
  int normalWater = 1;
  String brandNameDropDownValue = 'Bisleri';
  bool brandNameChanged = false;
  //var brandName = ['Bisleri', 'Kinley', 'Aquafina', 'Bailley', 'Himalayan', 'Bonaqua', 'Rail Neer' ,'Other'];
  List<String> brandName = [];
  String itemQuantityDropDownValue = '1L';
  bool itemQuantityChanged = false;
  var itemQuantity = [
    '1L',
    '1.5L',
    '2L',
    '250ml',
    '300ml',
    '350ml',
    '500ml',
    '750ml'
  ];
  int chargesDependentOnFloor = 1;
  TextEditingController bottlesPerPack = TextEditingController();
  TextEditingController packsAvailable = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController fromFloor = TextEditingController();
  TextEditingController otherBrandName = TextEditingController();
  TextEditingController floorCharges = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
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
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            )
          : Stack(
              //alignment: Alignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ADD WATER BOTTLE DETAILS',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Is it available in pack or not?',
                            style: TextStyle(
                                color: Color.fromRGBO(131, 131, 131, 1),
                                fontSize: 16),
                          ),
                          Row(
                            children: [
                              Radio(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                groupValue: availableToPack,
                                value: 1,
                                onChanged: (value) {
                                  setState(() {
                                    availableToPack = 1;
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
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                groupValue: availableToPack,
                                value: 0,
                                onChanged: (value) {
                                  setState(() {
                                    availableToPack = 0;
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
                          SizedBox(
                            height: availableToPack == 1 ? 8 : 0,
                          ),
                          availableToPack == 1
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Text(
                                        'How many bottles are Present in a pack?',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                131, 131, 131, 1),
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.2,
                                      child: TextFormField(
                                        controller: bottlesPerPack,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(fontSize: 11),
                                          contentPadding:
                                              const EdgeInsets.all(15),
                                          labelText: "",
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        validator: (val) {
                                          if (val!.isEmpty &&
                                              availableToPack == 1) {
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
                                )
                              : Container(),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.6,
                                child: Text(
                                  availableToPack == 1
                                      ? 'How many packs are available in your stock?'
                                      : 'How many bottles are available in your stock',
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1),
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                width: width * 0.2,
                                child: TextFormField(
                                  controller: packsAvailable,
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
                                    if (val!.isEmpty) {
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
                          SizedBox(
                            height: 14,
                          ),
                          ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              items: brandName.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  brandNameChanged = true;
                                  brandNameDropDownValue = newValue.toString();
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
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
                                    if (val!.isEmpty &&
                                        brandNameDropDownValue == 'Other') {
                                      return 'Required';
                                    }
                                  },
                                )
                              : Container(),
                          SizedBox(
                            height: brandNameDropDownValue == 'Other' ? 15 : 0,
                          ),
                          ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              items: itemQuantity.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  itemQuantityChanged = true;
                                  itemQuantityDropDownValue =
                                      newValue.toString();
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                labelText: "Item Quantity",
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
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
                            keyboardType: TextInputType.number,
                            controller: price,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: availableToPack == 1
                                  ? "Pack price"
                                  : "Price of each bottle",
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
                              if (val!.isEmpty) {
                                return 'Required';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                    SizedBox(
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
                                          return null;
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
                                      width: 5,
                                    ),
                                    SizedBox(
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
                                          LengthLimitingTextInputFormatter(3),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      'will increase.',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(131, 131, 131, 1),
                                          fontSize: 17,
                                          letterSpacing: 0.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 20,
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
                                              if (availableToPack == 1 &&
                                                  int.parse(bottlesPerPack
                                                          .text) ==
                                                      0) {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'Bottles in a pack cannot be zero');
                                                return;
                                              }
                                              if (int.parse(
                                                      packsAvailable.text) ==
                                                  0) {
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
                                                'bottlesPerPack':
                                                    availableToPack == 1
                                                        ? bottlesPerPack.text
                                                        : '0',
                                                'brandName': finalBrandName,
                                                'quantityAvailable':
                                                    packsAvailable.text,
                                                'qtyInLiters':
                                                    itemQuantityDropDownValue,
                                                'unitPrice': price.text,
                                                'fromFloor':
                                                    chargesDependentOnFloor == 1
                                                        ? fromFloor.text
                                                        : '0',
                                                'isWaterChilled':
                                                    normalWater == 1
                                                        ? false
                                                        : true,
                                                'floorCharges':
                                                    chargesDependentOnFloor == 1
                                                        ? floorCharges.text
                                                        : '0',
                                                'isDispenser': false,
                                                'isInPack': availableToPack == 1
                                                    ? true
                                                    : false,
                                                'imageLink': '',
                                                'supplierId':
                                                    Constants.mySupplierId,
                                                'locationId':
                                                    Constants.myLocationId,
                                                'type': 'Water Bottle',
                                                'threshold': '1000',
                                                'floorDependentCharges':
                                                    chargesDependentOnFloor == 1
                                                        ? true
                                                        : false
                                              };
                                              print(itemDetails);
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
                                              dataBaseMethods
                                                  .showToastNotification(
                                                      'Sucessfully Added Item');
                                              setState(() {
                                                loading = false;
                                              });
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
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
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
