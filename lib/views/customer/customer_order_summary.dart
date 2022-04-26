// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';

import '../../helper/constants.dart';

class CustomerOrderSummary extends StatefulWidget {
  String? phoneNo;
  String? name, address, noOfCans, walletBalance, id;
  bool isWalletNegative;

  CustomerOrderSummary(
      {Key? key,
      this.phoneNo,
      this.address,
      this.name,
      this.noOfCans,
      this.walletBalance,
      required this.isWalletNegative,
      this.id})
      : super(key: key);

  @override
  _CustomerOrderSummaryState createState() => _CustomerOrderSummaryState();
}

class _CustomerOrderSummaryState extends State<CustomerOrderSummary> {
  List<Map<String, dynamic>> customerOrders = [];
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = true;
  SaveData saveData = SaveData();
  TextEditingController noOfCans = TextEditingController();
  TextEditingController walletBalance = TextEditingController();
  bool cansChanged = false;
  bool balanceChanged = false;
  String _selectedDate = '';
  HelperFunctions helperFunctions = HelperFunctions();
  bool isWalletNegative = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var currDt = Constants.customerInfoDateTime;
    // print(currDt);
    var formatedDate = DateFormat('yyyy-MM-dd').format(currDt);
    _selectedDate = formatedDate;
    noOfCans.text = widget.noOfCans!;
    walletBalance.text = widget.walletBalance!;
    isWalletNegative = widget.isWalletNegative;
    // TODO: implement initState
    if (widget.walletBalance == '') {
      dataBaseMethods.fetchParticularCustomerInfo(widget.id).then((value) {
        print(widget.id);
        setState(() {
          print(value);
          widget.noOfCans =
              value['emptyCans'] == null ? '0' : value['emptyCans'].toString();
          noOfCans.text = widget.noOfCans!;
          widget.walletBalance = value['wallet'].toString();
          if (int.parse(widget.walletBalance!) < 0) {
            isWalletNegative = true;
            widget.walletBalance = widget.walletBalance!
                .substring(1, widget.walletBalance!.length);
          }
          walletBalance.text = widget.walletBalance!;
        });
      });
    } else {
      if (isWalletNegative) {
        walletBalance.text = '-' + walletBalance.text;
      }
    }
    dataBaseMethods.fetchCustomerOrders(widget.id, _selectedDate).then((value) {
      setState(() {
        loading = false;
        customerOrders = value;
        //   fetchAddress();

        //  address = saveData.fetchAddressFromMap(customerOrders['deliveryAddress']);
      });
    });
    super.initState();
  }

  updateData(selectedDate) {
    dataBaseMethods.fetchCustomerOrders(widget.id, _selectedDate).then((value) {
      setState(() {
        customerOrders = value;
        loading = false;
      });
    });
  }

  fetchAddress() {
    if (customerOrders.length == 0) return null;
    Map<String, dynamic> addressmap = customerOrders[0]['deliveryAddress'];

    widget.address = saveData.fetchAddressFromMap(addressmap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Customer Details',
          style: TextStyle(fontSize: 24),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (cansChanged || balanceChanged)
              Navigator.pop(context, true);
            else
              Navigator.pop(context, false);
          },
        ),
        backgroundColor: primaryColor,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (cansChanged || balanceChanged)
            Navigator.pop(context, true);
          else
            Navigator.pop(context, false);
          return false;
        },
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Text(
                                      widget.name!,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var phoneNumber = widget.phoneNo;
                                      var url = 'tel:$phoneNumber';

                                      await launch(url);
                                    },
                                    child: Text(
                                      "+91 " + widget.phoneNo!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Form(
                                              key: _formKey,
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.35,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Number of cans',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      height: 50,
                                                      child: TextFormField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        controller: noOfCans,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        // readOnly: isDelivered,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 5,
                                                                  bottom: 6),
                                                          isDense: false,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  '[0-9]+')),
                                                        ],
                                                        validator: (val) {
                                                          if (val!.length == 0)
                                                            return 'Required';
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Wallet Balance',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Row(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7 *
                                                              0.28,
                                                        ),
                                                        Text(
                                                          '₹',
                                                          style: TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          height: 50,
                                                          child: TextFormField(
                                                            textAlign: TextAlign
                                                                .center,
                                                            controller:
                                                                walletBalance,
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      bottom:
                                                                          6),
                                                              isDense: false,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color: Colors
                                                                            .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                            ),
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      '[0-9-]+')),
                                                            ],
                                                            validator: (val) {
                                                              if (val!.length ==
                                                                  0)
                                                                return 'Required';
                                                              return null;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Color.fromRGBO(
                                                          34, 164, 93, 1),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        onTap: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            bool success2 =
                                                                await dataBaseMethods
                                                                    .changeCansEngagedByParticularUser(
                                                                        widget
                                                                            .id,
                                                                        noOfCans
                                                                            .text);
                                                            bool success = await dataBaseMethods
                                                                .changeWalletBalanceOfParticularUser(
                                                                    widget.id,
                                                                    walletBalance
                                                                        .text);
                                                            if (!success ||
                                                                !success2)
                                                              return;
                                                            widget.noOfCans =
                                                                noOfCans.text;
                                                            widget.walletBalance =
                                                                walletBalance
                                                                    .text;
                                                            balanceChanged =
                                                                true;
                                                            cansChanged = true;
                                                            if (int.parse(
                                                                    walletBalance
                                                                        .text) <
                                                                0) {
                                                              isWalletNegative =
                                                                  true;
                                                              //    walletBalance.text = walletBalance.text.substring(1, walletBalance.text.length);
                                                              widget.walletBalance =
                                                                  walletBalance
                                                                      .text
                                                                      .substring(
                                                                          1,
                                                                          walletBalance
                                                                              .text
                                                                              .length);
                                                              ;
                                                            } else {
                                                              isWalletNegative =
                                                                  false;
                                                            }
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context, true);
                                                          }
                                                        },
                                                        child: Container(
                                                          // padding: EdgeInsets.symmetric(horizontal: 8),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                          child: const Center(
                                                            child: Text(
                                                              'Submit',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black12),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            widget.noOfCans!,
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          const Text(
                                            'NO. OF CANS',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 1),
                                                fontSize: 7,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 28,
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          Text.rich(
                                              TextSpan(text: '', children: [
                                            TextSpan(
                                              text: '₹ ',
                                              style: TextStyle(
                                                color: isWalletNegative
                                                    ? Colors.red
                                                        .withOpacity(0.87)
                                                    : primaryColor,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.walletBalance,
                                              style: TextStyle(
                                                color: isWalletNegative
                                                    ? Colors.red
                                                        .withOpacity(0.87)
                                                    : primaryColor,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ])),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          Text(
                                            isWalletNegative
                                                ? 'BALANCE DUE'
                                                : 'WALLET BALANCE',
                                            style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 1),
                                                fontSize: 7,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.address!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.parse(_selectedDate),
                                    lastDate:
                                        DateTime.now().add(Duration(days: 365)),
                                    firstDate: DateTime(2021),
                                  ).then((value) {
                                    if (value == null) return;
                                    Constants.customerInfoDateTime = value;
                                    setState(() {
                                      if (_selectedDate ==
                                          value.toString().substring(0, 10))
                                        return;
                                      _selectedDate =
                                          value.toString().substring(0, 10);
                                      // _selectedDate = helperFunctions.formatDate(_selectedDate);
                                      loading = true;

                                      updateData(_selectedDate);
                                    });
                                  });
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 1),
                                    width: 140,
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          helperFunctions
                                              .formatDate(_selectedDate),
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 30,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'ORDERS : ' + customerOrders.length.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          customerOrders.length == 0
                              ? Center(
                                  child: noDataDashboard(context),
                                )
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: customerOrders.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return customOrdersByParticularCustomer(
                                        context,
                                        customerOrders[index],
                                        widget.name,
                                        widget.phoneNo.toString());
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 0);
                                  },
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
