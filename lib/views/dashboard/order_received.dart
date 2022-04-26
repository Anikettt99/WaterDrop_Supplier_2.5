// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import '../complete_order_details.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class OrderReceived extends StatefulWidget {
  const OrderReceived({Key? key}) : super(key: key);

  @override
  _OrderReceivedState createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> {
  List<Map<String, dynamic>> orderReceived = [];
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();
  SaveData saveData = SaveData();
  bool loading = true;
  String slotOne = '', slotTwo = '';
  var timeItems = ['All Time'];
  String dateDropDownValue = 'Today';
  String timeDropDownValue = 'All Time';
  String _selectedDate = '';
  bool showCalendar = false;
  // ignore: prefer_typing_uninitialized_variables
  var currDt, formatedDate;
  String selectedId = '';
  String deliveryBoyName = '';
  String slotStartTime = '', slotEndTime = '';
  bool isUpdateNecessary = true;
  int page = 1;
  int limit = 15;
  bool hasMore = true;
  bool helperLoader = false;
  bool isLoadingVertical = false;
  bool fetchHelper = true;

  updateData(selectedDate) {
    dataBaseMethods
        .fetchOrderReceived(selectedDate, timeDropDownValue, page, limit)
        .then((value) {
      setState(() {
        orderReceived = value;
        loading = false;
      });
    });
  }

  bool isVersionGreaterThan(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");
    bool a = false;
    for (var i = 0; i <= 2; i++) {
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if (int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }

  _loadMoreVertical(startDate) {
    //  print("Call aa rha hai");

    if (hasMore == true) {
      setState(() {
        helperLoader = true;
      });

      if (fetchHelper == true) {
        setState(() {
          fetchHelper = false;
        });
        dataBaseMethods
            .fetchOrderReceived(startDate, 'All Time', page, limit)
            .then((value) {
          /* print("Total Orders are: ");
        print(value.length);*/
          if (value.isEmpty) {
            setState(() {
              hasMore = false;
              helperLoader = false;
              loading = false;
              fetchHelper = false;
            });
          } else {
            setState(() {
              orderReceived.addAll(value);
              // orderReceived = value;
              page = page + 1;
              isLoadingVertical = false;
              helperLoader = false;
              loading = false;
              fetchHelper = true;
            });
          }
        });
      }
    }
  }

  @override
  void initState() {
    Constants.slot2StartTime = '';
    Constants.slot2EndTime = '';
    currDt = Constants.orderReceivedDateTime;
    // print(currDt);
    formatedDate = DateFormat('yyyy-MM-dd').format(currDt);
    _selectedDate = formatedDate;
    getUserInfo().then((value) {
      timeItems.add(
          helperFunctions.parseDateTime(Constants.slot1StartTime, false) +
              ' to ' +
              helperFunctions.parseDateTime(Constants.slot1EndTime, false));
      if (Constants.slot2StartTime != '') {
        timeItems.add(
            helperFunctions.parseDateTime(Constants.slot2StartTime, false) +
                ' to ' +
                helperFunctions.parseDateTime(Constants.slot2EndTime, false));
      }
      _loadMoreVertical(formatedDate);
    });
    _checkVersion();
    super.initState();
  }

  void _checkVersion() async {
    //  print("check ho rha hai new version");
    final newVersion = NewVersion(androidId: "com.waterdrop.supplier");
    // final newVersion = NewVersion(androidId: "com.snapchat.android");
    String currentAppVersion = "";
    String AppStoreAppVersion = "";
    try {
      final update = await dataBaseMethods.checkNecessaryUpdate();
      final status = await newVersion.getVersionStatus();
      currentAppVersion = status!.localVersion;
      AppStoreAppVersion = status.storeVersion;
      if (status.storeVersion == update['version']) {
        setState(() {
          isUpdateNecessary = update['isNecessary'];
        });
      }
      print("--------------------------------");
      print(currentAppVersion);
      print(AppStoreAppVersion);
      print(update['version']);
      print("-----------------------------");
    } catch (e) {}
    bool isUpdateAvailable =
        isVersionGreaterThan(AppStoreAppVersion, currentAppVersion) ?? false;
    if (isUpdateAvailable) {
      showDialog(
        barrierDismissible: isUpdateNecessary,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    "Update WaterDrop?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    "WaterDrop Recommends that you update to the latest version. You can keep Ordering while downloading the app.",
                    style: TextStyle(fontSize: 13.5),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    isUpdateNecessary == true
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "No Thanks",
                              style: TextStyle(color: Color(0xff088c5c)),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: Colors.white,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width / 3.5, 40),
                            ),
                          ),
                    ElevatedButton(
                      onPressed: () async {
                        String link =
                            "https://play.google.com/store/apps/details?id=com.waterdrop.supplier";
                        await launch(link);
                      },
                      child: Row(
                        children: [
                          Image.network(
                            "https://cdn.pixabay.com/photo/2016/08/31/00/49/google-1632434_960_720.png",
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            "  Update ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff088c5c),
                        minimumSize:
                            Size(MediaQuery.of(context).size.width / 3.5, 40),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
    /* newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: "App Update Available!",
          dialogText: "Pls Update Your App To The Latest Version",
          allowDismissal: false); */
  }

  refreshData() {
    setState(() {
      loading = true;
      orderReceived = [];
      page = 1;
      hasMore = true;
      helperLoader = false;
      isLoadingVertical = false;
      fetchHelper = true;
      _loadMoreVertical(_selectedDate);
    });
    /* dataBaseMethods
        .fetchOrderReceived(_selectedDate, timeDropDownValue, page, limit)
        .then((value2) {
      setState(() {
        orderReceived = value2;
        loading = false;
      });
    });*/
  }

  refreshDataWithoutLoading() async {
    var value = await dataBaseMethods.fetchOrderReceived(
        _selectedDate, timeDropDownValue, page, limit);

    setState(() {
      orderReceived = value;
    });
    /* setState(() {
      loading = true;
      orderReceived = [];
      page = 1;
      hasMore = true;
      helperLoader = false;
      isLoadingVertical = false;
      fetchHelper = true;
      _loadMoreVertical(_selectedDate);
    });*/
  }

  getUserInfo() async {
    Constants.myLocationId =
        (await HelperFunctions.getLocationIdSharedPreference())!;
    Constants.myToken = (await HelperFunctions.getUserTokenSharedPreference())!;
    Constants.slot1StartTime =
        (await HelperFunctions.getUserSlot1StartTimeSharedPreference())!;
    Constants.slot2StartTime =
        (await HelperFunctions.getUserSlot2StartTimeSharedPreference())!;
    Constants.slot1EndTime =
        (await HelperFunctions.getUserSlot1EndTimeSharedPreference())!;
    Constants.slot2EndTime =
        (await HelperFunctions.getUserSlot2EndTimeSharedPreference())!;
  }

  Widget showLoader(index) {
    /* print("-------IF IT WILL SHOW LOADING");
    print(helperLoader);*/
    if (helperLoader == true) {
      if ((index + 1) % limit == 0) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget customOrdersReceivedCard2(
      context, Map<String, dynamic> ordersReceived, index, deliveryBoyName2) {
    String? name = ordersReceived['userId']['name'];
    String? orderId = ordersReceived['orderId'].toString();
    String? amount = ordersReceived['finalPaymentAmount'].toString();
    bool isDelivered = ordersReceived['status'] == 'DELIVERED' ? true : false;
    String? address =
        saveData.fetchAddressFromMap(ordersReceived['deliveryAddress']);
    String? phoneNo = '+91 ' + ordersReceived['userId']['phone'].toString();
    bool isPaid = ordersReceived['paymentStatus'] == 'PENDING' ? false : true;
    bool isUrgent = ordersReceived['urgency'] == 'URGENT' ? true : false;
    // print(ordersReceived['timeslotStart']);
    slotStartTime = helperFunctions.parseDateTime(
        ordersReceived['timeslotStart'].toString(), false);
    slotEndTime = helperFunctions.parseDateTime(
        ordersReceived['timeslotEnd'].toString(), false);
    List<dynamic> orders = orderReceived[index]['products'];
    String summarizedCart = helperFunctions.summarizeCart(orders);
    String paymentType = ordersReceived['paymentType'];
    deliveryBoyName = ordersReceived['deliveryBoyId'] == null && !isDelivered
        ? '- - -'
        : ordersReceived['deliveryBoyId'] == null
            ? 'Self'
            : ordersReceived['deliveryBoyId']['name'];
    String finalSlot = slotStartTime + ' - ' + slotEndTime;
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompleteOrderDetails(
                              orderDetails: ordersReceived,
                              deliveryBoyName: deliveryBoyName2,
                            ))).then((value) async {
                  if (value[1]) {
                    await refreshData();
                    return;
                  }
                  if (value[0] == 'Not Assigned') return;
                  if (value[0] != deliveryBoyName2) await refreshData();
                });
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        color: isUrgent
                            ? Color.fromRGBO(190, 0, 0, 1)
                            : Color.fromRGBO(34, 164, 93, 1),
                      ),
                      child: Center(
                        child: Text(
                          isUrgent ? 'Urgent' : 'Standard',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, left: 15, right: 15, top: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Order Id: ' + orderId,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              phoneNo,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              // width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                address!,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                summarizedCart,
                                style: const TextStyle(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: primaryColor,
                                      size: 17,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      child: Text(
                                        deliveryBoyName,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 1,
                                    ),
                                    !isDelivered
                                        ? IconButton(
                                            tooltip: 'Change Delivery Partner',
                                            constraints: const BoxConstraints(),
                                            splashRadius: 18,
                                            onPressed: () {
                                              showDialogBoxAndFetchDeliveryPartners(
                                                  ordersReceived[
                                                      'deliveryBoyId'],
                                                  ordersReceived['_id'],
                                                  index);
                                            },
                                            icon: Icon(Icons.edit),
                                            color: primaryColor,
                                            iconSize: 15,
                                            padding: EdgeInsets.zero,
                                          )
                                        : Container(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      CupertinoIcons.clock_fill,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      finalSlot,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  height: 20,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CompleteOrderDetails(
                                                  orderDetails: ordersReceived,
                                                  deliveryBoyName:
                                                      deliveryBoyName2,
                                                ))).then((value) async {
                                      if (value[0] == 'Not Assigned') return;
                                      if (value[0] != deliveryBoyName2 ||
                                          value[1]) await refreshData();
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'View More',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: primaryColor,
                                        size: 14,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(TextSpan(text: '', children: [
                    TextSpan(
                      text: '₹',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: amount,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ])),
                  Container(
                    width: 40,
                    height: 25,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(paymentType == 'COD'
                                ? 'assets/cash.jpg'
                                : 'assets/upi.jpg'))),
                  ),
                ],
              ),
            )
          ],
        ),
        /*Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(color: primaryColor,),
          ),
        )*/
        showLoader(index)
      ],
    );
  }

  showDialogBoxAndFetchDeliveryPartners(currentId, orderId, index) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowDialog(
              currentId: currentId == null ? '' : currentId['_id'],
              orderId: orderId);
        }).then((value) async {
      await refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await refreshData();
      },
      color: primaryColor,
      child: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(_selectedDate),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                      firstDate: DateTime(2021),
                    ).then((value) {
                      if (value == null) return;
                      setState(() {
                        _selectedDate = value.toString().substring(0, 10);
                        Constants.orderReceivedDateTime = value;
                        // _selectedDate = helperFunctions.formatDate(_selectedDate);
                        loading = true;
                        orderReceived = [];
                        page = 1;
                        hasMore = true;
                        helperLoader = false;
                        isLoadingVertical = false;
                        fetchHelper = true;
                        _loadMoreVertical(_selectedDate);
                        // updateData(_selectedDate);
                      });
                    });
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      width: 140,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            helperFunctions.formatDate(_selectedDate),
                            style: TextStyle(fontSize: 16),
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
                Card(
                  elevation: 3,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 1),
                    height: 30,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          dropdownColor: Colors.white,
                          elevation: 3,
                          iconSize: 32,
                          icon: const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.black,
                          ),
                          value: timeDropDownValue,
                          items: timeItems.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(fontSize: 16),
                                ));
                          }).toList(),
                          onChanged: (newValue) {
                            print(newValue);
                            if (newValue == "All Time") {
                              setState(() {
                                loading = true;
                                orderReceived = [];
                                page = 1;
                                hasMore = true;
                                helperLoader = false;
                                isLoadingVertical = false;
                                fetchHelper = true;
                                _loadMoreVertical(_selectedDate);
                              });
                            } else {
                              setState(() {
                                timeDropDownValue = newValue.toString();
                                loading = true;
                                updateData(_selectedDate);
                              });
                            }
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 15),
            child: Center(
              child: Text(
                "Total Orders Received : " + orderReceived.length.toString(),
                style: TextStyle(color: primaryColor, fontSize: 20),
              ),
            ),
          ),
          loading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  )))
              : RefreshIndicator(
                  onRefresh: () async {
                    await refreshDataWithoutLoading();
                  },
                  color: primaryColor,
                  child: Column(
                    children: [
                      orderReceived.isEmpty
                          ? Center(
                              child: Column(
                              children: [
                                noDataDashboard(context),
                              ],
                            ))
                          : SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.599,
                              child: LazyLoadScrollView(
                                isLoading: isLoadingVertical,
                                scrollOffset: 100,
                                onEndOfPage: () {
                                  _loadMoreVertical(_selectedDate);
                                },
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 0),
                                      child: ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: orderReceived.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          bool isDelivered =
                                              orderReceived[index]['status'] ==
                                                      'DELIVERED'
                                                  ? true
                                                  : false;
                                          String deliveryBoyName = orderReceived[
                                                              index]
                                                          ['deliveryBoyId'] ==
                                                      null &&
                                                  !isDelivered
                                              ? '- - -'
                                              : orderReceived[index]
                                                          ['deliveryBoyId'] ==
                                                      null
                                                  ? 'Self'
                                                  : orderReceived[index]
                                                      ['deliveryBoyId']['name'];
                                          return customOrdersReceivedCard2(
                                              context,
                                              orderReceived[index],
                                              index,
                                              deliveryBoyName);
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(height: 0);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class ShowDialog extends StatefulWidget {
  String? currentId, orderId;

  ShowDialog({Key? key, this.currentId, this.orderId}) : super(key: key);

  @override
  _ShowDialogState createState() => _ShowDialogState();
}

class _ShowDialogState extends State<ShowDialog> {
  String selectedId = '';
  List<Map<String, dynamic>> deliveryBoysName = [];
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = true;

  @override
  void initState() {
    selectedId = widget.currentId!;
    dataBaseMethods.fetchAvailableDeliveryBoys().then((value) {
      setState(() {
        loading = false;
        deliveryBoysName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              'Select Delivery Partner',
              style: TextStyle(fontSize: 22, color: primaryColor),
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 250,
              child: loading
                  ? const Center(
                      child: Text(
                        'Fetching Delivery Partners...Hold tight',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  : deliveryBoysName.isEmpty
                      ? const Center(
                          child: Text(
                            'Sorry, No Delivery Partners Available Right Now.',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Scrollbar(
                          thickness: 2,
                          isAlwaysShown: true,
                          child: ListView.builder(
                              itemCount: deliveryBoysName.length,
                              itemBuilder: (BuildContext context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Radio<String>(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          value: deliveryBoysName[index]['_id'],
                                          groupValue: selectedId,
                                          activeColor: primaryColor,
                                          onChanged: (value) async {
                                            setState(() {
                                              selectedId = value.toString();
                                            });
                                            //widget.callBackFn;
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Changing Delivery Partner');
                                            await dataBaseMethods
                                                .changeDeliveryBoyOfParticularOrder(
                                                    widget.orderId, value);
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Delivery Partner Changed');
                                            Navigator.pop(context);
                                          },
                                        ),
                                        Text(
                                          deliveryBoysName[index]['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
