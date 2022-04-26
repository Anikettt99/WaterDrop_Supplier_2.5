import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/google_maps_screen.dart';
import 'package:waterdrop_supplier/views/register/register_page.dart';

class StoreInformation extends StatefulWidget {
  final Function? onChangeCallBack, onBackCallBack;

  const StoreInformation({Key? key, this.onChangeCallBack, this.onBackCallBack})
      : super(key: key);

  @override
  _StoreInformationState createState() => _StoreInformationState();
}

class _StoreInformationState extends State<StoreInformation> {
  final _formKey = GlobalKey<FormState>();
  bool color1 = true;
  bool radio = true;
  int _radioSelected = 1;
  int _fastDeliverySelected = 1;
  String? _radioVal, _fastDeliveryVal;
  Map<String, dynamic> supplierDetails = {};
  String slotOneStart = '- - : - -';
  String slotOneEnd = '- - : - -';
  String slotTwoStart = '- - : - -';
  String slotTwoEnd = '- - : - -';

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();

  @override
  void initState() {
    print('!!!');
    if(supplier.slotOneStartHour != null && supplier.slotOneStartHour != ''){
      slotOneStart = helperFunctions.parseDateTime(supplier.slotOneStartHour!, true);
    }
    else {
      supplier.slotOneStartHour = '';
    }
    print('!!!');
    if(supplier.slotOneEndHour != null && supplier.slotOneEndHour != ''){
      slotOneEnd = helperFunctions.parseDateTime(supplier.slotOneEndHour!, true);
    }
    else {
      supplier.slotOneEndHour = '';
    }
    print('!!!');
    if(supplier.slotTwoStartHour != null && supplier.slotTwoStartHour != ''){
      slotTwoStart = helperFunctions.parseDateTime(supplier.slotTwoStartHour!, true);
    }
    else {
      supplier.slotTwoStartHour = '';
    }
    print('!!!');
    if(supplier.slotTwoEndHour != null && supplier.slotTwoEndHour != ''){
      slotTwoEnd = helperFunctions.parseDateTime(supplier.slotTwoEndHour!, true);
    }
    else {
      supplier.slotTwoEndHour = '';
    }
    latitudeController.text = supplier.storeLatitude ?? '';
    longitudeController.text = supplier.storeLongitude ?? '';
    print('ObcjbcjdbcK');
    super.initState();
  }

  @override
  void dispose() {
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 30),
            child: Text("STORE INFORMATION",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          buildDropContainer(
              context,
              width,
              height,
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      TextFormField(
                        initialValue: supplier.storeName,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Store name*",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 .]+')),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (name) {
                          if (name!.length == 0) {
                            return 'Required';
                          }
                        },
                        onSaved: (val) {
                          supplier.storeName = val;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: supplier.storeBuildingNo,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Building No., Building Name., Floor No.*",
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (name) {
                          if (name!.length == 0) {
                            return 'Required';
                          }
                        },
                        onSaved: (val) {
                          supplier.storeBuildingNo = val;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: supplier.storeColony,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Road Name, Area, Colony*",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (name) {
                          if (name!.length == 0) {
                            return 'Required';
                          }
                        },
                        onSaved: (val) {
                          supplier.storeColony = val;
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.43,
                            child: TextFormField(
                              initialValue: supplier.storeState,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                labelText: "State*",
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (name) {
                                if (name!.length == 0) {
                                  return 'Required';
                                }
                              },
                              onSaved: (val) {
                                supplier.storeState = val;
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.43,
                            child: TextFormField(
                              initialValue: supplier.storeCity,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                labelText: "City*",
                                border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (name) {
                                if (name!.length == 0) {
                                  return 'Required';
                                }
                              },
                              onSaved: (val) {
                                supplier.storeCity = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.43,
                            child: TextFormField(
                              initialValue: supplier.storePincode,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                labelText: "Pincode*",
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (name) {
                                if (name!.length != 0) {
                                  return name.length == 6
                                      ? null
                                      : 'Wrong Pincode';
                                }
                                return 'Required';
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                                LengthLimitingTextInputFormatter(6),
                              ],
                              onSaved: (val) {
                                supplier.storePincode = val;
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.43,
                            child: TextFormField(
                              initialValue: supplier.storeLandmark,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                labelText: "Landmark",
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (name) {
                                return null;
                              },
                              onSaved: (val) {
                                supplier.storeLandmark = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text("Contact number at store",
                          style: TextStyle(fontSize: 15, color: Colors.grey)),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        //maxLength: 10,
                        keyboardType: TextInputType.number,
                        initialValue: supplier.storePhNo,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Mobile number of store*",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: TextButton(
                            onPressed: null,
                            child: Text(
                              '+91 |',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                        validator: (name) {
                          return name!.length == 0
                              ? 'Required'
                              : name.length < 10 || name.length > 10
                                  ? 'invalid phone number'
                                  : null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onSaved: (val) {
                          supplier.storePhNo = val;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Whether you want security money?",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 1,
                                    groupValue: _radioSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _radioSelected = value as int;
                                        _radioVal = 'Yes';
                                      });
                                    },
                                  ),
                                  const Text("Yes"),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: 2,
                                    groupValue: _radioSelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _radioSelected = value as int;
                                        _radioVal = 'No';
                                        supplier.depositAmount = '0';
                                      });
                                    },
                                  ),
                                  const Text("No"),
                                ],
                              ),
                            ],
                          ),
                          _radioSelected == 1
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "How Much? ",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    Text(
                                      "₹ ",
                                      style: TextStyle(
                                          color: primaryColor, fontSize: 16),
                                    ),
                                    Container(
                                      width: 90,
                                      child: TextFormField(
                                        initialValue: supplier.depositAmount,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12))),
                                        onSaved: (val) {
                                          supplier.depositAmount = val;
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                                          LengthLimitingTextInputFormatter(3)
                                        ],
                                        validator: (val){
                                          if(_radioSelected == 1){
                                            if(val!.length == 0)
                                              return 'Required';
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),

                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Whether you provide fast delivery (within 2 to 3 hours)?",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    value: 1,
                                    groupValue: _fastDeliverySelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _fastDeliverySelected = value as int;
                                        _fastDeliveryVal = 'Yes';
                                      });
                                    },
                                  ),
                                  const Text("Yes"),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                    value: 2,
                                    groupValue: _fastDeliverySelected,
                                    activeColor: Colors.blue,
                                    onChanged: (value) {
                                      setState(() {
                                        _fastDeliverySelected = value as int;
                                        _fastDeliveryVal = 'No';
                                        supplier.fastDeliveryCharges = '0';
                                      });
                                    },
                                  ),
                                  const Text("No"),
                                ],
                              ),
                            ],
                          ),
                          _fastDeliverySelected == 1
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Fast Delivery Charges - ",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                "₹ ",
                                style: TextStyle(
                                    color: primaryColor, fontSize: 16),
                              ),
                              Container(
                                width: 90,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: supplier.fastDeliveryCharges,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(12))),
                                  onSaved: (val) {
                                    supplier.fastDeliveryCharges = val;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                  validator: (val){
                                    if(_fastDeliverySelected == 1){
                                      if(val!.length == 0)
                                        return 'Required';
                                    }
                                  },
                                ),
                              )
                            ],
                          )
                              : Container(),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Enter Slot Time",
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            "Add Slot 1 Time*",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: width * 0.2,
                            height: 30,
                            child: Center(
                              child: TextFormField(
                               // initialValue: supplier.slotOneStartHour,
                                textAlign: TextAlign.center,
                                onTap: () {
                                  showCustomTimePicker(
                                      context: context,
                                      onFailValidation: (context) => dataBaseMethods.showToastNotification('Invalid Time Chosen'),
                                      initialTime: TimeOfDay(
                                        hour: DateTime.now()
                                            .hour,
                                        minute:
                                        0,),
                                      selectableTimePredicate: (time) => time!.minute == 0
                                  )
                                      .then((value) {
                                    setState(() {
                                      String hr = value!.hour.toString();
                                      String minute = value.minute.toString();
                                      if (minute.length == 1)
                                        minute = '0' + minute;
                                      slotOneStart =
                                          value.format(context).toString();
                                      supplier.slotOneStartHour =
                                          hr + ":" + minute;
                                    });
                                  });
                                },
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: slotOneStart,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
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
                                ],
                                onSaved: (val) {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "To",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: width * 0.2,
                            height: 30,
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onTap: () {
                                  showCustomTimePicker(
                                      context: context,
                                      onFailValidation: (context) => dataBaseMethods.showToastNotification('Invalid Time Chosen'),
                                      initialTime: TimeOfDay(
                                        hour: DateTime.now()
                                            .hour,
                                        minute:
                                        0,),
                                      selectableTimePredicate: (time) => time!.minute == 0
                                  )
                                      .then((value) {
                                    setState(() {
                                      String hr = value!.hour.toString();
                                      String minute = value.minute.toString();
                                      if (minute.length == 1)
                                        minute = '0' + minute;
                                      slotOneEnd =
                                          value.format(context).toString();
                                      supplier.slotOneEndHour =
                                          hr + ":" + minute;
                                      print(supplier.slotOneEndHour);
                                    });
                                  });
                                },
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: slotOneEnd,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
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
                                ],
                                onSaved: (val) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            "Add Slot 2 Time ",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            width: 11,
                          ),
                          Container(
                            width: width * 0.2,
                            height: 30,
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onTap: () {
                                  showCustomTimePicker(
                                      context: context,
                                      onFailValidation: (context) => dataBaseMethods.showToastNotification('Invalid Time Chosen'),
                                      initialTime: TimeOfDay(
                                        hour: DateTime.now()
                                            .hour,
                                        minute:
                                        0,),
                                      selectableTimePredicate: (time) => time!.minute == 0
                                  )
                                      .then((value) {
                                    setState(() {
                                      String hr = value!.hour.toString();
                                      String minute = value.minute.toString();
                                      if (minute.length == 1)
                                        minute = '0' + minute;
                                      slotTwoStart =
                                          value.format(context).toString();
                                      supplier.slotTwoStartHour =
                                          hr + ":" + minute;
                                      print(supplier.slotTwoStartHour);
                                    });
                                  });
                                },
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: slotTwoStart,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
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
                                ],
                                onSaved: (val) {
                                  // supplier.slotTwoStartHour = slotTwoHourStart;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "To",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: width * 0.2,
                            height: 30,
                            child: Center(
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                onTap: () {
                                  showCustomTimePicker(
                                      context: context,
                                      onFailValidation: (context) => dataBaseMethods.showToastNotification('Invalid Time Chosen'),
                                      initialTime: TimeOfDay(
                                        hour: DateTime.now()
                                            .hour,
                                        minute:
                                        0,),
                                      selectableTimePredicate: (time) => time!.minute == 0
                                  )
                                      .then((value) {
                                    setState(() {
                                      String hr = value!.hour.toString();
                                      String minute = value.minute.toString();
                                      if (minute.length == 1)
                                        minute = '0' + minute;
                                      slotTwoEnd =
                                          value.format(context).toString();
                                      supplier.slotTwoEndHour =
                                          hr + ":" + minute;
                                      print(supplier.slotTwoEndHour);
                                    });
                                  });
                                },
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: slotTwoEnd,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 5),
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
                                ],
                                onSaved: (val) {
                                  // supplier.slotTwoEndHour = slotTwoHourEnd;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              'Store Details',
              true),
          const Divider(
            thickness: 5,
            color: Color(0xFFE6E6E6),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
            child: Text("Select Store's location on the map",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.3,
                  height: 40,
                  child: TextFormField(
                    controller: latitudeController,
                  //  initialValue: supplier.storeLatitude,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "Latitude",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Container(
                  width: width * 0.3,
                  height: 40,
                  child: TextFormField(
                 //   initialValue: supplier.storeLongitude,
                   controller: longitudeController,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintText: "Longitude",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  color: primaryColor,
                  onPressed: () async {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => GoogleMapsScreen()))
                        .then((value) {
                          print(value);
                          if(value == null)
                            return;
                      setState(() {
                        latitudeController.text = value!.latitude.toString();
                        longitudeController.text = value!.longitude.toString();
                        supplier.storeLatitude = latitudeController.text;
                        supplier.storeLongitude = longitudeController.text;
                      });
                    });
                    //  DataBaseMethods dataBaseMethods = DataBaseMethods();
                    //  await dataBaseMethods.getLatLngFromAddress('1600 Amphitheatre Parkway, Mountain View, CA');
                  },
                  child: Text(
                    'Open map',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text('Note: Choose your location in the map same as written in above fields.', style: TextStyle(
              color: Color.fromRGBO(131, 131, 131, 1),
              fontSize: 14,
              fontStyle: FontStyle.italic

            )
            ),
          ),
          const Divider(
            thickness: 5,
            color: Color(0xFFE6E6E6),
          ),
          buildDropContainer(
            context,
            width,
            height,
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      initialValue: supplier.ownerName,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "Full name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        /*suffixIcon: Icon(
                          CupertinoIcons.check_mark,
                          color: secondaryColor,
                        ),*/
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z .]+')),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      validator: (name) {
                        if (name!.length == 0) {
                          return 'Required';
                        }
                        if(name.length > 20){
                          return 'Name cant be more than 20 characters';
                        }
                      },
                      onSaved: (val) {
                        supplier.ownerName = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      initialValue: supplier.ownerEmail,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "Owner's email address (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onSaved: (val) {
                        supplier.ownerEmail = val;
                      },
                    ),
                  ],
                ),
              ),
            ),
            'Store owner details',
            false,
          ),
          const Divider(
            thickness: 5,
            height: 20,
            color: Color(0xFFE6E6E6),
          ),
          buildDropContainer(
            context,
            width,
            height,
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: supplier.aadhar,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "AADHAR number of the owner",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        /*suffixIcon: Icon(
                          CupertinoIcons.check_mark,
                          color: secondaryColor,
                        ),*/
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (val) {
                        if(val == null || val == '')
                          return null;
                        if(val.length != 12)
                          return 'Invalid Aadhar Number';
                      },
                      onSaved: (val) {
                        supplier.aadhar = val;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      initialValue: supplier.aadharName,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "Card Holder Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z .]+')),
                      ],
                      onSaved: (val) {
                        supplier.aadharName = val;
                      },
                    ),
                  ],
                ),
              ),
            ),
            'AADHAR Details(Optional)',
            false,
          ),
          const Divider(
            thickness: 5,
            height: 20,
            color: Color(0xFFE6E6E6),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: GestureDetector(
                    child: Container(
                      width: 120,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.arrowtriangle_left_fill,
                            size: 12,
                            color: primaryColor,
                          ),
                          Text(
                            "  GO BACK",
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {Navigator.pop(context)},
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if(latitudeController.text == "" || latitudeController.text == '0.0' || longitudeController.text == '0.0'){
                          DataBaseMethods().showToastNotification('Select Store\'s Location in Map');
                          return;
                        }
                        if(supplier.slotOneStartHour == '' || supplier.slotOneEndHour == ''){
                          DataBaseMethods().showToastNotification('Slot one timings are required');
                          return;
                        }
                        if(supplier.slotTwoEndHour == '' && supplier.slotTwoStartHour != ''){
                          DataBaseMethods().showToastNotification('Invalid slot details');
                          return;
                        }
                        if(supplier.slotTwoEndHour != '' && supplier.slotTwoStartHour == ''){
                          DataBaseMethods().showToastNotification('Invalid slot details');
                          return;
                        }
                        if(!helperFunctions.isValidSlotTime(supplier.slotOneStartHour, supplier.slotTwoStartHour, supplier.slotOneEndHour, supplier.slotTwoEndHour)){
                          DataBaseMethods().showToastNotification('Invalid slot details');
                          return;
                        }
                        widget.onChangeCallBack!();
                      }
                    },
                    child: nextButton()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
