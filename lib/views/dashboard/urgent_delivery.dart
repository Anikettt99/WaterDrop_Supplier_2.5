import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import '../complete_order_details.dart';

int updateDataIndex = 0;
String updatedDeliveryBoyId = '';

class UrgentDelivery extends StatefulWidget {
  const UrgentDelivery({Key? key}) : super(key: key);

  @override
  _UrgentDeliveryState createState() => _UrgentDeliveryState();
}

class _UrgentDeliveryState extends State<UrgentDelivery> {
  List<Map<String, dynamic>> urgentOrders = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();
  bool loading = true;
  SaveData saveData = SaveData();
  String deliveryBoyName = '';

  Widget customOrdersReceivedCard2(
      context, Map<String, dynamic> ordersReceived, index, deliveryBoyName2) {
    String? name = ordersReceived['userId']['name'];

    String? orderId = ordersReceived['orderId'].toString();
    String? amount = ordersReceived['finalPaymentAmount'].toString();
    String? address =
        saveData.fetchAddressFromMap(ordersReceived['deliveryAddress']);
    String? phoneNo = '+91 ' + ordersReceived['userId']['phone'].toString();
    bool isPaid = ordersReceived['paymentStatus'] == 'PENDING' ? false : true;
    bool isUrgent = ordersReceived['urgency'] == 'URGENT' ? true : false;
    String slotStartTime = helperFunctions.parseDateTime(
        ordersReceived['timeslotStart'].toString(), false);
    String slotEndTime = helperFunctions.parseDateTime(
        ordersReceived['timeslotEnd'].toString(), false);
    List<dynamic> orders = ordersReceived['products'];
    print(orders);
    String summarizedCart = helperFunctions.summarizeCart(orders);
    String paymentType = ordersReceived['paymentType'];
    deliveryBoyName = ordersReceived['deliveryBoyId'] == null
        ? '- - -'
        : ordersReceived['deliveryBoyId']['name'];
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CompleteOrderDetails(orderDetails: ordersReceived, deliveryBoyName: deliveryBoyName2,)))
                .then((value) async {
              if (value[1]) {
                initState();
                return;
              }
              if (value[0] == 'Not Assigned') return;
              if (value[0] != deliveryBoyName) initState();
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
                       //   width: MediaQuery.of(context).size.width * 0.6,
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
                        Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
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
                                  width: 2,
                                ),
                                IconButton(
                                  tooltip: 'Change Delivery Partner',
                                  constraints: const BoxConstraints(),
                                  splashRadius: 18,
                                  onPressed: () {
                                    showDialogBoxAndFetchDeliveryPartners(
                                        ordersReceived['deliveryBoyId'],
                                        ordersReceived['_id'],
                                        index);
                                  },
                                  icon: Icon(Icons.edit),
                                  color: primaryColor,
                                  iconSize: 15,
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(
                                  width: 15,
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
                                  slotStartTime.toLowerCase() +
                                      ' - ' +
                                      slotEndTime.toLowerCase(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
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
                                                    orderDetails:
                                                        ordersReceived)))
                                    .then((value) async {
                                  if (value[0] != deliveryBoyName) initState();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'View More',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: primaryColor,
                                    size: 15,
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
                        image: AssetImage(paymentType == 'COD' ? 'assets/cash.jpg' : 'assets/upi.jpg')
                    )
                ),
              ),
            ],
          ),
        )
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
      initState();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    var currDt = DateTime.now();
    var formatedDate = DateFormat('yyyy-MM-dd').format(currDt);
    dataBaseMethods.fetchUrgentOrders(formatedDate).then((value) {
      setState(() {
        urgentOrders = value;
        loading = false;
      });
    });

    super.initState();
  }

  refreshDataWithoutLoading() async {
    var currDt = DateTime.now();
    var formatedDate = DateFormat('yyyy-MM-dd').format(currDt);
    var value = await dataBaseMethods.fetchUrgentOrders(formatedDate);
    setState(() {
      urgentOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: CircularProgressIndicator(color: primaryColor,)))
        : urgentOrders.length == 0
            ? RefreshIndicator(
                onRefresh: () async {
                  await refreshDataWithoutLoading();
                },
                child: Center(
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        child: noDataDashboard(context))))
            : RefreshIndicator(
                onRefresh: () async {
                  await refreshDataWithoutLoading();
                },
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 15),
                      child: Center(
                        child: Text(
                          "Total Urgent Orders: " +
                              urgentOrders.length.toString(),
                          style: TextStyle(color: secondaryColor, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: urgentOrders.length,
                        itemBuilder: (BuildContext context, index) {
                          String deliveryBoyName =
                          urgentOrders[index]
                          ['deliveryBoyId'] ==
                              null
                              ? '- - -'
                              : urgentOrders[index]
                          ['deliveryBoyId']
                          ['name'];
                          return customOrdersReceivedCard2(
                              context, urgentOrders[index], index, deliveryBoyName);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 0);
                        },
                      ),
                    ),
                    SizedBox(
                      height: urgentOrders.length < 3 ? 200 : 30,
                    )
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
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = true;

  @override
  void initState() {
    selectedId = widget.currentId!;
    dataBaseMethods.fetchDeliveryBoys().then((value) {
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
      child: Container(
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
                  : deliveryBoysName.length == 0
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
