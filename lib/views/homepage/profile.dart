// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/help_and_support.dart';
import 'package:waterdrop_supplier/views/landing_page.dart';
import 'package:waterdrop_supplier/views/view_qr_code.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  _ProfileHomeState createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  HelperFunctions helperFunctions = HelperFunctions();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController aadhar = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController securityDeposit = TextEditingController();
  TextEditingController fastDeliveryCharges = TextEditingController();
  final GlobalKey phoneExpansionTile = new GlobalKey();
  String slotOneStartBackend = Constants.slot1StartTime;
  String slotOneEndBackend = Constants.slot1EndTime;
  String slotTwoStartBackend = Constants.slot2StartTime;
  String slotTwoEndBackend = Constants.slot2EndTime;
  String slotOneStart = '';
  String slotOneEnd = '';
  String slotTwoStart = '';
  String slotTwoEnd = '';
  ScrollController scrollController = ScrollController();
  bool isAadharAdded = true;
  bool isPanAdded = true;
  bool isGSTNumberAdded = true;
  bool loggingOut = false;

  @override
  void initState() {
    print(slotOneStartBackend);
    slotOneStart = helperFunctions.parseDateTime(slotOneStartBackend, true);
    print(slotOneEndBackend);
    slotOneEnd = helperFunctions.parseDateTime(slotOneEndBackend, true);
    print(slotOneStart);
    print(slotOneEnd);
    if (slotTwoStartBackend != '') {
      slotTwoStart = helperFunctions.parseDateTime(slotTwoStartBackend, true);
      slotTwoEnd = helperFunctions.parseDateTime(slotTwoEndBackend, true);
    } else {
      slotTwoStart = '- - : - -';
      slotTwoEnd = '- - : - -';
    }
    securityDeposit.text = Constants.securityDepositAmount;
    fastDeliveryCharges.text = Constants.fastDeliveryCharges;
    if (Constants.myAadharNumber == "") isAadharAdded = false;
    if (Constants.myPanCardNumber == "") isPanAdded = false;
    if (Constants.myGSTNumber == "") isGSTNumberAdded = false;
    print('Hi');
    // TODO: implement initState
    super.initState();
  }

  logMeOut() async {
    setState(() {
      loggingOut = true;
    });
    dataBaseMethods.logOut().then((value) async {
      if (value == true) {
        await HelperFunctions.saveUserLoggedInSharedPreference(false);
        // Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      } else {
        setState(() {
          loggingOut = false;
          dataBaseMethods.showToastNotification('Error while logging out');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          //padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/headerS.png',
                          ),
                          fit: BoxFit.fill)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80, left: 20),
                  child: Row(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.width * 0.24,
                          width: MediaQuery.of(context).size.width * 0.23,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/personIcon.jpeg',
                                  ),
                                  fit: BoxFit.fill),
                              shape: BoxShape.circle)),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              'Hi, ' + Constants.myStoreName,
                              style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            'Supplier\'s Code: ' + Constants.myCode.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(50),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'User Profile',
                    style: TextStyle(fontSize: 26, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Container(
              height: height * 0.6,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 50),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width / 40),
                  ),
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: Scrollbar(
                      controller: scrollController,
                      isAlwaysShown: true,
                      thickness: 2.5,
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ViewQrCode()));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.qr_code,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title:
                                   const Text(
                                    'QR Code',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.access_time_filled,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: const Text(
                                    'Slots',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  trailing: Text(
                                    'Change',
                                    style: TextStyle(color: primaryColor),
                                  ),
                                  childrenPadding: EdgeInsets.all(width / 40),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Edit Slot 1 Time ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700,
                                              letterSpacing: 0.8),
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
                                              onTap: () async {
                                                /*await showCustomTimePicker(context: context, initialTime: TimeOfDay(
                                                    hour: DateTime.now()
                                                    .hour,
                                                minute:
                                                0),
                                                    onFailValidation: (context) => dataBaseMethods.showToastNotification('Unavailable Selection'),
                                                selectableTimePredicate: (time) => time!.minute % 30 == 0
                                                ).then((value) {
                                                      print(value);
                                                });*/

                                                showCustomTimePicker(
                                                    context: context,
                                                    onFailValidation: (context) =>
                                                        dataBaseMethods
                                                            .showToastNotification(
                                                                'Invalid Time Chosen'),
                                                    initialTime: TimeOfDay(
                                                      hour: DateTime.now().hour,
                                                      minute: 0,
                                                    ),
                                                    selectableTimePredicate:
                                                        (time) =>
                                                            time!.minute ==
                                                            0).then((value) {
                                                  if (value == null) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    String hr =
                                                        value.hour.toString();
                                                    String minute =
                                                        value.minute.toString();
                                                    if (minute.length == 1)
                                                      minute = '0' + minute;
                                                    slotOneStartBackend =
                                                        hr + ":" + minute;
                                                    slotOneStart = value
                                                        .format(context)
                                                        .toString();
                                                  });
                                                });
                                              },
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: slotOneStart,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 5),
                                                isDense: false,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (name) {},
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9]+')),
                                              ],
                                              onSaved: (val) {
                                                //supplier.slotOneStartHour = slotOneHourStart;
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
                                              fontSize: 16,
                                              color: Colors.grey.shade700),
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
                                                    onFailValidation: (context) =>
                                                        dataBaseMethods
                                                            .showToastNotification(
                                                                'Invalid Time Chosen'),
                                                    initialTime: TimeOfDay(
                                                      hour: DateTime.now().hour,
                                                      minute: 0,
                                                    ),
                                                    selectableTimePredicate:
                                                        (time) =>
                                                            time!.minute ==
                                                            0).then((value) {
                                                  if (value == null) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    String hr =
                                                        value.hour.toString();
                                                    String minute =
                                                        value.minute.toString();
                                                    if (minute.length == 1)
                                                      minute = '0' + minute;
                                                    slotOneEndBackend =
                                                        hr + ":" + minute;
                                                    slotOneEnd = value
                                                        .format(context)
                                                        .toString();
                                                  });
                                                });
                                              },
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: slotOneEnd,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 5),
                                                isDense: false,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (name) {},
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9]+')),
                                              ],
                                              onSaved: (val) {
                                                //  supplier.slotOneEndHour = slotOneHourEnd;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Edit Slot 2 Time ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700,
                                              letterSpacing: 0.8),
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
                                                    onFailValidation: (context) =>
                                                        dataBaseMethods
                                                            .showToastNotification(
                                                                'Invalid Time Chosen'),
                                                    initialTime: TimeOfDay(
                                                      hour: DateTime.now().hour,
                                                      minute: 0,
                                                    ),
                                                    selectableTimePredicate:
                                                        (time) =>
                                                            time!.minute ==
                                                            0).then((value) {
                                                  if (value == null) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    String hr =
                                                        value.hour.toString();
                                                    String minute =
                                                        value.minute.toString();
                                                    if (minute.length == 1)
                                                      minute = '0' + minute;
                                                    slotTwoStartBackend =
                                                        hr + ":" + minute;
                                                    //  hr = helperFunctions.parseDateTime(hr, false);
                                                    //print(hr);
                                                    slotTwoStart = value
                                                        .format(context)
                                                        .toString();
                                                  });
                                                });
                                              },
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: slotTwoStart,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 5),
                                                isDense: false,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (name) {},
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9]+')),
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
                                              fontSize: 16,
                                              color: Colors.grey.shade700),
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
                                                    onFailValidation: (context) =>
                                                        dataBaseMethods
                                                            .showToastNotification(
                                                                'Invalid Time Chosen'),
                                                    initialTime: TimeOfDay(
                                                      hour: DateTime.now().hour,
                                                      minute: 0,
                                                    ),
                                                    selectableTimePredicate:
                                                        (time) =>
                                                            time!.minute ==
                                                            0).then((value) {
                                                  if (value == null) {
                                                    return;
                                                  }
                                                  setState(() {
                                                    String hr =
                                                        value.hour.toString();
                                                    String minute =
                                                        value.minute.toString();
                                                    if (minute.length == 1) {
                                                      minute = '0' + minute;
                                                    }
                                                    slotTwoEndBackend =
                                                        hr + ":" + minute;
                                                    slotTwoEnd = value
                                                        .format(context)
                                                        .toString();
                                                  });
                                                });
                                              },
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: slotTwoEnd,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 5),
                                                isDense: false,
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (name) {},
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9]+')),
                                              ],
                                              onSaved: (val) {
                                                //    supplier.slotTwoEndHour = slotTwoHourEnd;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                        color: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        onPressed: () async {
                                          if (slotTwoStartBackend != '' &&
                                              slotTwoEndBackend == '') {
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Invalid Details');
                                            return;
                                          }
                                          if (slotTwoStartBackend == '' &&
                                              slotTwoEndBackend != '') {
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Invalid Details');
                                            return;
                                          }
                                          bool success = await dataBaseMethods
                                              .updateLocation({
                                            'slot1Start': slotOneStartBackend,
                                            'slot1End': slotOneEndBackend,
                                            'slot2Start': slotTwoStartBackend,
                                            'slot2End': slotTwoEndBackend
                                          });
                                          if (!success) {
                                            return;
                                          }
                                          await HelperFunctions
                                              .saveUserSlot1StartTimeSharedPreference(
                                                  slotOneStartBackend);
                                          await HelperFunctions
                                              .saveUserSlot2StartTimeSharedPreference(
                                                  slotTwoStartBackend);
                                          await HelperFunctions
                                              .saveUserSlot1EndTimeSharedPreference(
                                                  slotOneEndBackend);
                                          await HelperFunctions
                                              .saveUserSlot2EndTimeSharedPreference(
                                                  slotTwoEndBackend);
                                          Constants.slot1StartTime =
                                              slotOneStartBackend;
                                          Constants.slot1EndTime =
                                              slotOneEndBackend;
                                          Constants.slot2StartTime =
                                              slotTwoStartBackend;
                                          Constants.slot2EndTime =
                                              slotTwoEndBackend;
                                        },
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.white, height: 1.4),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    "Change",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    Constants.securityDepositAmount == ""
                                        ? 'Security Money'
                                        : 'Security Money - ₹ ' +
                                            Constants.securityDepositAmount,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: const EdgeInsets.all(10.0),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '  ₹ ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55,
                                              height: 40,
                                              child: TextFormField(
                                                controller: securityDeposit,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  hintText:
                                                      "Update Security Money",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp('[0-9]+')),
                                                  LengthLimitingTextInputFormatter(
                                                      3)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FlatButton(
                                            color: primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            onPressed: () async {
                                              if (Constants
                                                      .securityDepositAmount ==
                                                  securityDeposit.text) {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'New Value same as previous value');
                                                return;
                                              }
                                              if (securityDeposit.text == "") {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'No value added');
                                                return;
                                              }
                                              bool success =
                                                  await dataBaseMethods
                                                      .updateLocation({
                                                'securityDepositAmount':
                                                    securityDeposit.text
                                              });
                                              if (!success) {
                                                return;
                                              }
                                              await HelperFunctions
                                                  .saveUserSecurityDepositAmountSharedPreference(
                                                      securityDeposit.text);
                                              Constants.securityDepositAmount =
                                                  securityDeposit.text;
                                              securityDeposit.text = "";
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'Update',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.4),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    "Change",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.delivery_dining,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    Constants.fastDeliveryCharges == ""
                                        ? 'Fast Delivery Charges'
                                        : 'Fast Delivery Charges - ₹ ' +
                                            Constants.fastDeliveryCharges,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: const EdgeInsets.all(10.0),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '  ₹ ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55,
                                              height: 40,
                                              child: TextFormField(
                                                controller: fastDeliveryCharges,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  hintText:
                                                      "Fast Delivery Charges",
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp('[0-9]+')),
                                                  LengthLimitingTextInputFormatter(
                                                      3)
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: FlatButton(
                                            color: primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            onPressed: () async {
                                              if (Constants
                                                      .fastDeliveryCharges ==
                                                  fastDeliveryCharges.text) {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'New Value same as previous value');
                                                return;
                                              }
                                              if (fastDeliveryCharges.text ==
                                                  "") {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'No value added');
                                                return;
                                              }
                                              bool success =
                                                  await dataBaseMethods
                                                      .updateLocation({
                                                'fastDeliveryCharges':
                                                    fastDeliveryCharges.text
                                              });
                                              if (!success) {
                                                return;
                                              }
                                              await HelperFunctions
                                                  .saveUserFastDeliveryChargeSharedPreference(
                                                      fastDeliveryCharges.text);
                                              Constants.fastDeliveryCharges =
                                                  fastDeliveryCharges.text;
                                              fastDeliveryCharges.text = "";
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'Update',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.4),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  key: phoneExpansionTile,
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    "Change",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: width / 20,
                                    child: const Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    Constants.myPhoneNumber.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: EdgeInsets.all(width / 40),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: TextFormField(
                                              controller: phoneNo,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorHeight: 25,
                                              decoration: InputDecoration(
                                                prefixIcon: TextButton(
                                                  onPressed: null,
                                                  child: Text(
                                                    '+91 ',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600),
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(15),
                                                labelText: "Enter Phone No",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp('[0-9]+')),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          height: 48,
                                          child: FlatButton(
                                            color: primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            onPressed: () {
                                              if (Constants.myPhoneNumber
                                                      .toString() ==
                                                  phoneNo.text) {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'Phone number same as previous number');
                                                return;
                                              }
                                              if (phoneNo.text.length == 10) {
                                                dataBaseMethods
                                                    .generateOTP(phoneNo.text);
                                              } else {
                                                dataBaseMethods
                                                    .showToastNotification(
                                                        'Invalid Phone Number');
                                              }
                                            },
                                            child: const Text(
                                              'Get OTP',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.4),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    OTPTextField(
                                      length: 4,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      fieldWidth:
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                      style: TextStyle(fontSize: 20),
                                      textFieldAlignment:
                                          MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.underline,
                                      onCompleted: (otp) async {
                                        await dataBaseMethods
                                            .verifyPhoneUpdateOTP(
                                                phoneNo.text, otp);
                                        await HelperFunctions
                                            .savePhoneNumberSharedPreference(
                                                int.parse(phoneNo.text));
                                        setState(() {
                                          Constants.myPhoneNumber =
                                              int.parse(phoneNo.text);
                                          phoneNo.text = "";
                                          initState();
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            "Enter the otp sent to your mobile no.")),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 20,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  Constants.myAddress,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    "Change",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.mail,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    Constants.myMail == ''
                                        ? 'No Mail Added'
                                        : Constants.myMail,
                                    style: TextStyle(
                                      color: Constants.myMail == ''
                                          ? Color.fromRGBO(131, 131, 131, 1)
                                          : Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: const EdgeInsets.all(10.0),
                                  children: [
                                    TextFormField(
                                      controller: email,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                        labelText: "Enter new mail id",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                        color: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        onPressed: () async {
                                          if (email.text.length == 0) {
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Enter Email');
                                          } else if (RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(email.text)) {
                                            bool success = await dataBaseMethods
                                                .updateLocation(
                                                    {'email': email.text});
                                            if (!success) {
                                              return;
                                            }
                                            await HelperFunctions
                                                .saveUserMailIdSharedPreference(
                                                    email.text);
                                            Constants.myMail = email.text;
                                            email.text = "";
                                            setState(() {});
                                          } else {
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Invalid Email Format');
                                          }
                                        },
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.white, height: 1.4),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    isAadharAdded ? "View" : "Add",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: width / 20,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: const Text(
                                    'Aadhar Number',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: EdgeInsets.all(width / 40),
                                  children: [
                                    isAadharAdded
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Aadhar Number"),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  Constants.myAadharNumber
                                                          .substring(0, 4) +
                                                      ' ' +
                                                      Constants.myAadharNumber
                                                          .substring(4, 8) +
                                                      ' ' +
                                                      Constants.myAadharNumber
                                                          .substring(8, 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          )
                                        : TextFormField(
                                            controller: aadhar,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              labelText:
                                                  "Enter Aadhar Card Number",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9]+')),
                                              LengthLimitingTextInputFormatter(
                                                  12)
                                            ],
                                          ),
                                    isAadharAdded
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              onPressed: () async {
                                                if (aadhar.text.length == 0) {
                                                  dataBaseMethods
                                                      .showToastNotification(
                                                          'No Number Added');
                                                } else if (aadhar.text.length !=
                                                    12) {
                                                  dataBaseMethods
                                                      .showToastNotification(
                                                          'Invalid Aadhar Number');
                                                } else {
                                                  bool success =
                                                      await dataBaseMethods
                                                          .updateLocationFinanceDetails({
                                                    'aadhar': aadhar.text,
                                                    'supplierId':
                                                        Constants.mySupplierId
                                                  });
                                                  if (!success) {
                                                    return;
                                                  }
                                                  await HelperFunctions
                                                      .saveUserAadharCardSharedPreference(
                                                          aadhar.text);
                                                  Constants.myAadharNumber =
                                                      aadhar.text;
                                                  isAadharAdded = true;
                                                  aadhar.text = "";
                                                  setState(() {});
                                                }
                                              },
                                              child: const Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    height: 1.4),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    isPanAdded ? "View" : "Add",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: width / 20,
                                    child: const Icon(
                                      Icons.credit_card,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: const Text(
                                    'Pan Number',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: EdgeInsets.all(width / 40),
                                  children: [
                                    isPanAdded
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("Pan Number"),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  Constants.myPanCardNumber,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          )
                                        : TextFormField(
                                            controller: pan,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              labelText:
                                                  "Enter PAN Card Number",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9a-zA-Z]+')),
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                          ),
                                    isPanAdded
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              onPressed: () async {
                                                if (pan.text.length == 0) {
                                                  dataBaseMethods
                                                      .showToastNotification(
                                                          'No Number Added');
                                                } else {
                                                  bool success =
                                                      await dataBaseMethods
                                                          .updateLocationFinanceDetails({
                                                    'panNumber': pan.text,
                                                    'supplierId':
                                                        Constants.mySupplierId
                                                  });
                                                  if (!success) {
                                                    return;
                                                  }
                                                  await HelperFunctions
                                                      .saveUserPanCardSharedPreference(
                                                          pan.text);
                                                  Constants.myPanCardNumber =
                                                      pan.text;
                                                  isPanAdded = true;
                                                  pan.text = "";
                                                  setState(() {});
                                                }
                                              },
                                              child: const Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    height: 1.4),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: false,
                                  trailing: Text(
                                    isGSTNumberAdded ? "View" : 'Add',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: width / 20,
                                    child: const Icon(
                                      Icons.book,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: const Text(
                                    'Gst Number',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  childrenPadding: EdgeInsets.all(width / 40),
                                  children: [
                                    isGSTNumberAdded
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text("GST Number"),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  Constants.myGSTNumber,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ],
                                          )
                                        : TextFormField(
                                            controller: gst,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.all(15),
                                              labelText: "Enter GST Number",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp('[0-9a-zA-Z]+')),
                                              LengthLimitingTextInputFormatter(
                                                  15),
                                            ],
                                          ),
                                    isGSTNumberAdded
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.centerRight,
                                            child: FlatButton(
                                              color: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              onPressed: () async {
                                                if (gst.text.length == 0) {
                                                  dataBaseMethods
                                                      .showToastNotification(
                                                          'No Number Added');
                                                } else {
                                                  bool success =
                                                      await dataBaseMethods
                                                          .updateLocationFinanceDetails({
                                                    'gstinNumber': gst.text,
                                                    'supplierId':
                                                        Constants.mySupplierId
                                                  });
                                                  if (!success) {
                                                    return;
                                                  }
                                                  await HelperFunctions
                                                      .saveUserGSTNumberSharedPreference(
                                                          gst.text);
                                                  Constants.myGSTNumber =
                                                      gst.text;
                                                  isGSTNumberAdded = true;
                                                  gst.text = "";
                                                  setState(() {});
                                                }
                                              },
                                              child: const Text(
                                                'Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    height: 1.4),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HelpAndSupport()));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.help,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: const Text(
                                    'Help & Support',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 55, right: 20),
                                child: Divider(
                                  thickness: 1.0,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          title: const Text(
                                              'Are you sure you want to log out?'),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      logMeOut();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.red
                                                          .withOpacity(0.87),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    child: const Text('Yes')),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                    child: const Text('No'))
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                  //  logMeOut();
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    radius: 20,
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    loggingOut ? 'Logging Out' : 'Log Out',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5)
                            ],
                          ),
                        ],
                      ),
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
