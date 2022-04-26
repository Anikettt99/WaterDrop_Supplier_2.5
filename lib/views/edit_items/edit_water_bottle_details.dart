import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';

class EditWaterBottleDetails extends StatefulWidget {
  Map<String, dynamic> details;

  EditWaterBottleDetails({Key? key, required this.details}) : super(key: key);

  @override
  _EditWaterBottleDetailsState createState() => _EditWaterBottleDetailsState();
}

class _EditWaterBottleDetailsState extends State<EditWaterBottleDetails> {
  int availableToPack = 1;
  int normalWater = 1;
  String brandNameDropDownValue = 'Bisleri';
  bool brandNameChanged = false;
  List<String> brandName = [];
  String itemQuantityDropDownValue = '2L';
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
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  Map<String, dynamic> details = {};
  bool loading = false;

  @override
  void initState() {
    dataBaseMethods.fetchBrandName().then((value) {
      print(value);
      setState(() {
        brandName = value;
        brandName.add("Other");
        // isLoading = false;
      });
    });

    details = widget.details;
    brandNameDropDownValue = details['brandName'];
    if (!brandName.contains(details['brandName'])) {
      brandNameDropDownValue = 'Other';
    }

    itemQuantityDropDownValue = details['qtyInLiters'];
    normalWater = details['isWaterChilled'] ? 0 : 1;
    availableToPack = details['isInPack'] ? 1 : 0;
    chargesDependentOnFloor = details['floorDependentCharges'] ? 1 : 0;
    // TODO: implement initState
    super.initState();
  }

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
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              //physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EDIT WATER BOTTLE DETAILS',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width * 0.6,
                                child: Text(
                                  'How many bottles are Present in a pack?',
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1),
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                width: width * 0.2,
                                child: TextFormField(
                                  initialValue:
                                      details['bottlesPerPack'].toString(),
                                  //  controller: bottlesPerPack,
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
                                    if (val!.length == 0 &&
                                        availableToPack == 1) {
                                      return 'Required';
                                    }
                                    if (int.parse(val) == 0 &&
                                        availableToPack == 1) {
                                      dataBaseMethods.showToastNotification(
                                          'Bottles in a pack cannot be zero');
                                      return '';
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]+')),
                                  ],
                                  onSaved: (val) {
                                    details['bottlesPerPack'] = val;
                                  },
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
                        Container(
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
                        Container(
                          width: width * 0.2,
                          child: TextFormField(
                            initialValue:
                                details['quantityAvailable'].toString(),
                            //      controller: packsAvailable,
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
                              if (int.parse(val) == 0) {
                                dataBaseMethods.showToastNotification(
                                    'Stock cannot be zero');
                                return '';
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]+')),
                            ],
                            onSaved: (val) {
                              details['quantityAvailable'] = val;
                            },
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
                        value: brandNameDropDownValue,
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
                          // labelText: "Select Brand Name",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
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
                            initialValue: details['brandName'],
                            //     controller: otherBrandName,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              //  labelText: "Enter Brand Name",
                              labelStyle: TextStyle(fontSize: 15),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
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
                            onSaved: (val) {
                              details['brandName'] = val;
                            },
                          )
                        : Container(),
                    SizedBox(
                      height: brandNameDropDownValue == 'Other' ? 15 : 0,
                    ),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        value: itemQuantityDropDownValue,
                        items: itemQuantity.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            itemQuantityChanged = true;
                            itemQuantityDropDownValue = newValue.toString();
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          // labelText: "Item Quantity(L)",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
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
                      initialValue: details['unitPrice'].toString(),
                      keyboardType: TextInputType.number,
                      //  controller: price,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: availableToPack == 1
                            ? "Pack price"
                            : "Price of each bottle",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
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
                        FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                      ],
                      validator: (val) {
                        if (val!.length == 0) {
                          return 'Required';
                        }
                        if (int.parse(val) == 0) {
                          return 'Price cannot be zero';
                        }
                      },
                      onSaved: (val) {
                        details['unitPrice'] = val;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    askForFloorCharges(),
                    chargesDependentOnFloor == 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('From',
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1),
                                      fontSize: 17,
                                      letterSpacing: 0.5)),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: width * 0.13,
                                height: 25,
                                child: TextFormField(
                                  initialValue: details['fromFloor'] == null
                                      ? '0'
                                      : details['fromFloor'].toString(),
                                  //    controller: fromFloor,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    isDense: false,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (name) {},
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]+')),
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                  onSaved: (val) {
                                    details['fromFloor'] = val;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('floor ₹',
                                  style: TextStyle(
                                      color: Color.fromRGBO(131, 131, 131, 1),
                                      fontSize: 17,
                                      letterSpacing: 0.5)),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: width * 0.13,
                                height: 25,
                                child: TextFormField(
                                  initialValue: details['floorCharges'] == null
                                      ? '0'
                                      : details['floorCharges'].toString(),
                                  //    controller: floorCharges,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    isDense: false,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (name) {},
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]+')),
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                  onSaved: (val) {
                                    details['floorCharges'] = val;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'will increase.',
                                style: TextStyle(
                                    color: Color.fromRGBO(131, 131, 131, 1),
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
                            onPressed: loading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      details['brandName'] =
                                          brandNameDropDownValue == 'Other'
                                              ? details['brandName']
                                              : brandNameDropDownValue;
                                      details['qtyInLiters'] =
                                          itemQuantityDropDownValue;
                                      if (chargesDependentOnFloor == 0) {
                                        details['floorDependentCharges'] =
                                            false;
                                        details['fromFloor'] = '0';
                                        details['floorCharges'] = '0';
                                      } else {
                                        details['floorDependentCharges'] = true;
                                      }
                                      details['isWaterChilled'] =
                                          normalWater == 1 ? false : true;
                                      details['isInPack'] =
                                          availableToPack == 1 ? true : false;
                                      print(details);
                                      setState(() {
                                        loading = true;
                                      });
                                      await dataBaseMethods.editItemDetails(
                                          details['_id'], details);
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    index: 0,
                                                  )));
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
                                fontSize: 18, fontWeight: FontWeight.w500),
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
