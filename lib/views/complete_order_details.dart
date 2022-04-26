import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import 'package:waterdrop_supplier/views/homepage/dashboard.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';

import 'customer/customer_order_summary.dart';

class CompleteOrderDetails extends StatefulWidget {
  Map<String, dynamic> orderDetails;
  String? name, phoneNo, deliveryBoyName;

  CompleteOrderDetails(
      {Key? key,
      required this.orderDetails,
      this.phoneNo,
      this.name,
      this.deliveryBoyName = ''})
      : super(key: key);

  @override
  _CompleteOrderDetailsState createState() => _CompleteOrderDetailsState();
}

class _CompleteOrderDetailsState extends State<CompleteOrderDetails> {
  HelperFunctions helperFunctions = HelperFunctions();
  TextEditingController totalCans = TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  TextEditingController noOfCansReturnedController = TextEditingController();
  TextEditingController additionalCommentsController = TextEditingController();
  TextEditingController amountReceivedController = TextEditingController();
  String deliveryBoyName = '';
  bool isDelivered = false, isCancelled = false;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  bool isDeliveredMarked = false;
  bool isPaid = false;
  List<bool> reason = [false, false, false, false];
  int _radioSelected = -1;
  String reasonForCancellation = '';

  @override
  void initState() {
    print(widget.orderDetails);
    noOfCansReturnedController.text = '0';
    amountReceivedController.text = '0';
    deliveryBoyName =
        (widget.deliveryBoyName == '' || widget.deliveryBoyName == '- - -'
            ? 'Not Assigned'
            : widget.deliveryBoyName)!;
    isDelivered = widget.orderDetails['status'] == 'DELIVERED' ? true : false;
    isPaid = widget.orderDetails['paymentStatus'] == 'PENDING' ? false : true;
    // TODO: implement initState
    super.initState();
  }

  cancelOrder(mongoId) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Cancel Your Order',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    color: Colors.blue.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.info,
                            color: primaryColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Text(
                              'The following information is only for our records and will not prevent you from cancelling your order',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Reasons for cancellation (Optional):',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 0,
                          groupValue: _radioSelected,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as int;
                              reasonForCancellation = 'Change My Mind';
                            });
                          },
                        ),
                        Text('Change my mind')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        /*Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            checkColor: Colors.white,
                            activeColor: primaryColor,
                            value: reason[1],
                            onChanged: (val) {
                              setState(() {
                                reason[1] = !reason[1];
                              });
                            }),*/
                        Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 1,
                          groupValue: _radioSelected,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as int;
                              reasonForCancellation = 'Wrong Shipping Address';
                            });
                          },
                        ),
                        Text('Wrong shipping address')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 2,
                          groupValue: _radioSelected,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as int;
                              reasonForCancellation = 'Duplicate Order';
                            });
                          },
                        ),
                        Text('Duplicate order')
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 3,
                          groupValue: _radioSelected,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _radioSelected = value as int;
                              reasonForCancellation = 'Other';
                            });
                          },
                        ),
                        Text('Other')
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Additional Comments:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          TextFormField(
                              maxLength: 200,
                              controller: additionalCommentsController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (name) {
                                if (name!.length == 0) {
                                  return 'Required';
                                }
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    side: BorderSide(color: primaryColor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 8),
                                  //  width: 65,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    //color: Color.fromRGBO(4, 127, 196, 1)
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Never Mind',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: Container(
                                  // padding: EdgeInsets.symmetric(horizontal: 8),
                                  //  width: 65,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    //color: Color.fromRGBO(4, 127, 196, 1)
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Cancel Order',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          });
        }).then((val) async {
      _radioSelected = -1;
      reason = [false, false, false, false];
      if (val == null) {
        return;
      }
      if (val) {
        String additionalComments = '';
        if (additionalCommentsController.text.isEmpty) {
          additionalComments = '';
        } else {
          additionalComments = additionalCommentsController.text;
        }
        Map<String, dynamic> body = {
          'reason': reasonForCancellation,
          'comments': additionalComments
        };
        bool success = await dataBaseMethods.cancelOrder(mongoId, body);
        if (success) {
          Navigator.pop(context, [true, true]);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        index: 2,
                        dashBoardIndex: 4,
                        getUserData: false,
                      )));
        }
      }
    });
  }

  showDialogBoxAndFetchDeliveryPartners(currentId, orderId) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowDialog(
              currentId: currentId == null ? '' : currentId['_id'],
              orderId: orderId);
        }).then((value) {
      if (value == null) return;
      setState(() {
        deliveryBoyName = value[0];
        if (widget.orderDetails['deliveryBoyId'] == null) {
          widget.orderDetails['deliveryBoyId'] = [
            {'_id': value[1]}
          ];
        } else {
          widget.orderDetails['deliveryBoyId']['_id'] = value[1];
        }
        //  initState();
      });
    });
  }

  Widget orderDetailsView(BuildContext context,
      Map<String, dynamic> orderDetails, nameDefault, phoneDefault) {
    SaveData saveData = new SaveData();
    List<dynamic> orders = orderDetails['products'];
    String? name = orderDetails['userId'].length == 24
        ? nameDefault
        : orderDetails['userId']['name'];
    String? orderId = orderDetails['orderId'] ?? 'XXXXXXXXXXX';
    String? amount = orderDetails['finalPaymentAmount'].toString();
    String? walletBalanceUsed = orderDetails['walletMoneyUsed'].toString();
    isDelivered = orderDetails['status'] == 'DELIVERED' ? true : false;
    isCancelled = orderDetails['status'] == 'CANCELLED' ? true : false;
    String? address =
        saveData.fetchAddressFromMap(orderDetails['deliveryAddress']);
    String? phoneNo = orderDetails['userId'].length == 24
        ? phoneDefault
        : orderDetails['userId']['phone'];
    phoneNo = '+91 ' + phoneNo!;

    DateTime receiveTimeIST = DateTime.parse(orderDetails['createdAt']);
    receiveTimeIST = receiveTimeIST.add(Duration(hours: 5, minutes: 30));
    String? receiveTime = receiveTimeIST.toString().substring(11, 16);
    receiveTime = helperFunctions.parseDateTime(receiveTime, true);
    String? receiveDate = receiveTimeIST.toString().substring(0, 10);
    receiveDate = helperFunctions.formatDate(receiveDate);
    String? deliveryDate = '', deliveryTime = '';
    if (isDelivered) {
      DateTime deliveryTimeIST = DateTime.parse(orderDetails['deliveryTime']);
      deliveryTimeIST = deliveryTimeIST.add(Duration(hours: 5, minutes: 30));
      deliveryDate = deliveryTimeIST.toString().substring(0, 10);
      deliveryDate = helperFunctions.formatDate(deliveryDate);
      deliveryTime = deliveryTimeIST.toString().substring(11, 16);
      deliveryTime = helperFunctions.parseDateTime(deliveryTime, true);
    }
    String? fastDeliveryCharge = orderDetails['fastDeliveryCharges'].toString();
    String slotStartTime = helperFunctions.parseDateTime(
        orderDetails['timeslotStart'].toString(), false);
    String slotEndTime = helperFunctions.parseDateTime(
        orderDetails['timeslotEnd'].toString(), false);
    bool isUrgent = orderDetails['urgency'] == 'URGENT' ? true : false;
    String totalItemCost = orderDetails['paymentAmount'].toString();
    String paymentType = orderDetails['paymentType'].toString();
    paymentType = paymentType == 'COD' ? 'Cash On Delivery' : paymentType;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 100,
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isUrgent
                      ? Color.fromRGBO(190, 0, 0, 1)
                      : Color.fromRGBO(34, 164, 93, 1),
                ),
                child: Center(
                  child: Text(
                    isUrgent ? 'URGENT' : 'STANDARD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerOrderSummary(
                                  name: name,
                                  phoneNo: orderDetails['userId']['phone'],
                                  address: address,
                                  noOfCans: '',
                                  walletBalance: '',
                                  isWalletNegative: false,
                                  id: orderDetails['userId']['_id'],
                                )));
                  },
                  child: Text(
                    name!,
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  isCancelled
                      ? 'Cancelled'
                      : isDelivered
                          ? 'Delivered'
                          : 'Not Delivered',
                  style: TextStyle(
                      color: isCancelled
                          ? Color.fromRGBO(131, 131, 131, 1)
                          : isDelivered
                              ? Colors.green
                              : Colors.amber,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    address!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    var location =
                        "https://maps.google.com/?q=${orderDetails['deliveryAddress']['latitude']},${orderDetails['deliveryAddress']['longitude']}";
                    var url = location;
                    await launch(url);
                  },
                  icon: Icon(
                    CupertinoIcons.location_fill,
                    color: primaryColor,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.person,
                  color: primaryColor,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  deliveryBoyName,
                  style: TextStyle(
                      color: deliveryBoyName == 'Not Assigned'
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  width: 10,
                ),
                !isDelivered && !isCancelled
                    ? IconButton(
                        tooltip: 'Change Delivery Partner',
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                        onPressed: () {
                          showDialogBoxAndFetchDeliveryPartners(
                              orderDetails['deliveryBoyId'],
                              orderDetails['_id']);
                        },
                        icon: Icon(Icons.edit),
                        color: primaryColor,
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  CupertinoIcons.clock_fill,
                  color: primaryColor,
                  size: 20,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Number of Cans',
                    style: TextStyle(fontSize: 12.8),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  !isDelivered
                      ? /*Container(
                          width: MediaQuery.of(context).size.width * 0.13,
                          height: 30,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: totalCans,
                            keyboardType: TextInputType.number,
                            readOnly: isDelivered,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                  top: 5, bottom: 6),
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
                          ),
                        )*/
                      Text('- - -')
                      : Text(orderDetails['cansReturned'].toString()),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount Received  ',
                    style: TextStyle(fontSize: 12.8),
                  ),
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "₹",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: orderDetails['cashReceived'] != null
                              ? orderDetails['cashReceived'].toString()
                              : '0',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500))
                    ]),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                !isDelivered
                    ? listDashedLines()
                    : Column(
                        children: [
                          Icon(
                            CupertinoIcons.stop_circle_fill,
                            color: primaryColor,
                            size: 18,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: primaryColor,
                          ),
                        ],
                      ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Order Received',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  receiveDate,
                  style: const TextStyle(
                      color: Color.fromRGBO(131, 131, 131, 1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            isDelivered
                ? Row(
                    children: [
                      Icon(
                        CupertinoIcons.stop_circle_fill,
                        color: primaryColor,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Order Delivered',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 33,
                      ),
                      Text(
                        deliveryDate,
                        style: const TextStyle(
                            color: Color.fromRGBO(131, 131, 131, 1),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                : Row(),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items Ordered',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  isPaid ? 'PAID' : 'UNPAID',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isPaid ? Colors.green : Colors.amber),
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: orders.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return orderDetailsCartCard(orders[index], context);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 1,
                );
              },
            ),
            const Divider(
              thickness: 1.5,
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total (' + orders.length.toString() + ' Items)',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.end,
                    ),
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "₹ ",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: totalItemCost,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500))
                      ]),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isUrgent
                          ? 'Fast Delivery Charge'
                          : 'Standard Delivery Charge',
                      style: const TextStyle(color: Colors.black),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '₹ ' + fastDeliveryCharge,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    )
                  ],
                ),
                walletBalanceUsed == '0'
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Wallet Balance',
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '- ₹ ' + walletBalanceUsed,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Amount Payable',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                ),
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "₹ ",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                        text: amount,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500))
                  ]),
                )
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Order Details',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Order ID',
              style: TextStyle(
                //color: Color.fromRGBO(131, 131, 131, 1),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              orderId!,
              style: const TextStyle(
                //color: Color.fromRGBO(131, 131, 131, 1),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Payment Method',
              style: TextStyle(
                //color: Color.fromRGBO(131, 131, 131, 1),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              paymentType,
              style: const TextStyle(
                //color: Color.fromRGBO(131, 131, 131, 1),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Delivery Date',
              style: TextStyle(
                //color: Color.fromRGBO(131, 131, 131, 1),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              deliveryDate == '' ? '- -' : deliveryDate,
              style: const TextStyle(
                //color: Color.fromRGBO(131, 131, 131, 1),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        //color: Color.fromRGBO(131, 131, 131, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      phoneNo,
                      style: const TextStyle(
                        //color: Color.fromRGBO(131, 131, 131, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      var phoneNumber = orderDetails['userId']['phone'];
                      var url = 'tel:$phoneNumber';

                      await launch(url);
                    },
                    icon: Icon(
                      CupertinoIcons.phone_fill,
                      color: primaryColor,
                    )),
              ],
            ),
            SizedBox(
              height: isDelivered || isCancelled ? 20 : 43,
            ),
            /*Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 100,
                height: 33,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isUrgent
                      ? Color.fromRGBO(190, 0, 0, 1)
                      : Color.fromRGBO(34, 164, 93, 1),
                ),
                child: Center(
                  child: Text(
                    isUrgent ? 'URGENT' : 'STANDARD',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget orderDetailsCartCard(orderDetails, context) {
    HelperFunctions helperFunctions = HelperFunctions();
    String? itemName = helperFunctions.getItemName(orderDetails['productId']);
    String imageLink = orderDetails['productId']['imageLink'];
    String quantityOrdered = orderDetails['productQty'].toString();
    String unitPrice = orderDetails['unitPrice'].toString();
    String totalPrice = orderDetails['totalPrice'].toString();
    String floorCharges = orderDetails['floorCharges'].toString();
    int unitItemFloorCharges =
        (orderDetails['floorCharges'] / orderDetails['productQty']).floor();
    bool isInPack = orderDetails['productId']['isInPack'] ?? false;
    bool isWaterChilled = orderDetails['productId']['isWaterChilled'] ?? false;
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width * 0.15,
            height: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(imageLink),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: width * 0.72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWaterChilled ? itemName + '(Chilled)' : itemName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: isInPack ? 5 : 0,
                ),
                isInPack == true
                    ? Text(
                        '(A Pack Of ' +
                            orderDetails['productId']['bottlesPerPack']
                                .toString() +
                            ')',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500),
                      )
                    : Container(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 150, 255, 0.2),
                            border: Border.all(color: Colors.blueAccent),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Center(
                            child: Text(
                              quantityOrdered,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'x ₹' + unitPrice,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Text(
                      '₹' +
                          (int.parse(quantityOrdered) * int.parse(unitPrice))
                              .toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                floorCharges == '0'
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Floor Charges (₹' +
                                    unitItemFloorCharges.toString() +
                                    ' x ' +
                                    quantityOrdered +
                                    ')',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(131, 131, 131, 1),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹' + floorCharges,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
          /*Expanded(
            // width: MediaQuery.of(context).size.width * 0.30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Quantity: ' + quantityOrdered,
                  style: const TextStyle(
                      color: Color.fromRGBO(131, 131, 131, 1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Unit Price: ₹' + unitPrice,
                  style: const TextStyle(
                      color: Color.fromRGBO(131, 131, 131, 1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Floor Charges: ₹ ' + floorCharges,
                  style: const TextStyle(
                      color: Color.fromRGBO(131, 131, 131, 1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  'Total Price: ₹' + totalPrice,
                  style: const TextStyle(
                      color: Color.fromRGBO(131, 131, 131, 1),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, [deliveryBoyName, isDeliveredMarked]);
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Order Details',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: primaryColor,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, [deliveryBoyName, isDeliveredMarked]);
          return false;
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                orderDetailsView(
                    context, widget.orderDetails, widget.name, widget.phoneNo)
              ],
            ),
            !isDelivered && !isCancelled
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(color: primaryColor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              cancelOrder(widget.orderDetails['_id']);
                            },
                            child: Container(
                              height: 38,
                              child: Center(
                                child: Text(
                                  ' Cancel Order ',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Total Number of cans returned',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: 50,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      noOfCansReturnedController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  // readOnly: isDelivered,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            top: 5, bottom: 6),
                                                    isDense: false,
                                                    border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp('[0-9]+')),
                                                  ],
                                                  validator: (val) {
                                                    if (val!.length == 0)
                                                      return 'Required';
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Text(
                                                'Amount Received in Cash',
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
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7 *
                                                            0.28,
                                                  ),
                                                  Text(
                                                    '₹',
                                                    style: TextStyle(
                                                        color: primaryColor,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
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
                                                      controller:
                                                          amountReceivedController,
                                                      keyboardType:
                                                          TextInputType.number,
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
                                                                  .circular(8),
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
                                                ],
                                              ),
                                              Material(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Color.fromRGBO(
                                                    34, 164, 93, 1),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  onTap: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      bool success = await dataBaseMethods
                                                          .changeOrderStatusToDelivered(
                                                              widget.orderDetails[
                                                                  '_id'],
                                                              noOfCansReturnedController
                                                                  .text,
                                                              amountReceivedController
                                                                  .text);
                                                      if (!success) return;
                                                      setState(() {
                                                        isDeliveredMarked =
                                                            true;
                                                        isDelivered = true;
                                                        widget.deliveryBoyName =
                                                            'Self';
                                                        'DELIVERED';
                                                        widget.orderDetails[
                                                                'deliveryTime'] =
                                                            DateTime.now()
                                                                .toIso8601String();
                                                        widget.orderDetails[
                                                                'cansReturned'] =
                                                            noOfCansReturnedController
                                                                .text;
                                                        widget.orderDetails[
                                                                'cashReceived'] =
                                                            amountReceivedController
                                                                .text;
                                                        widget.deliveryBoyName =
                                                            'Self';
                                                        isPaid = true;
                                                      });
                                                      Navigator.pop(
                                                          context, true);
                                                      // Navigator.pop(context, [deliveryBoyName, isDeliveredMarked]);
                                                    }
                                                  },
                                                  child: Container(
                                                    // padding: EdgeInsets.symmetric(horizontal: 8),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                    child: const Center(
                                                      child: Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                            color: Colors.white,
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
                                }).then((value) {
                              if (value == null) return;

                              setState(() {
                                isDelivered = true;
                                isDeliveredMarked = true;
                                widget.orderDetails['status'] = 'DELIVERED';
                              });
                            });
                          },
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 8),
                            //  width: 65,
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              //color: Color.fromRGBO(4, 127, 196, 1)
                            ),
                            child: const Center(
                              child: Text(
                                ' Mark As Delivered ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
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
    // TODO: implement initState
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
                                            Navigator.pop(context, [
                                              deliveryBoysName[index]['name'],
                                              deliveryBoysName[index]['_id']
                                            ]);
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
