// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import 'package:waterdrop_supplier/views/complete_order_details.dart';
import 'package:waterdrop_supplier/views/notifications.dart';

import 'constants.dart';

Color primaryColor = const Color(0xFF006BFF);
Color secondaryColor = const Color(0xFF4285F4);

Widget customAppBar(context, currentIndex) {
  return AppBar(
    // automaticallyImplyLeading: false,
    centerTitle: true,
    backgroundColor: primaryColor,
    title: Text(
      currentIndex == 0
          ? 'Item Information'
          : currentIndex == 1
              ? 'Statistics'
              : currentIndex == 2
                  ? 'Dashboard'
                  : currentIndex == 3
                      ? 'Delivery Boy'
                      : 'Vehicle',
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Notifications()));
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 8, right: 12),
          child: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        ),
      ),
    ],
    elevation: 0,
  );
}

Widget customButton(BuildContext context, height, width, String text,
    Color containerColor, Color textColor, Color borderColor) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 4),
              blurRadius: 4)
        ]),
    child: Center(
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 17),
      ),
    ),
  );
}

Widget buildDropContainer(
  BuildContext context,
  double width,
  double height,
  Container container,
  String heading,
  bool isClosed,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
          maintainState: true,
          initiallyExpanded: isClosed,
          title: Text(
            heading,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
          children: [
            container,
          ],
        ),
      ),
    ),
  );
}

Widget buildCircleCont(
    BuildContext context, double width, double height, int num, int selected) {
  return Column(
    children: [
      Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: num == selected ? primaryColor : Colors.white,
          border:
              Border.all(color: num == selected ? primaryColor : Colors.grey),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2), // border width
          child: Center(
            child: Text(
              num.toString(),
              style: TextStyle(
                  color: num == selected ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget customAddOrRemoveButton(BuildContext context, height, width, String text,
    IconData icon, Color containerColor, textSize) {
  return Container(
    padding: EdgeInsets.only(left: 5),
    height: height,
    width: width,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 26,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: textSize * 1.0),
        )
      ],
    ),
  );
}

Widget customItemCard(BuildContext context, Map<String, dynamic> listedItems) {
  HelperFunctions helperFunctions = HelperFunctions();
 // print(listedItems);
  String imageLink = listedItems['imageLink'];
  String price = listedItems['unitPrice'].toString();
  String quantity = listedItems['qtyInLiters'].toString();
  String itemType = listedItems['type'];
  String productName = helperFunctions.getItemName(listedItems);
  String stock = listedItems['quantityAvailable'].toString();
  String isChilled =
      listedItems['isWaterChilled'] == null || !listedItems['isWaterChilled']
          ? ''
          : '(Chilled)';
  bool isDispenser = listedItems['isDispenser'];
  bool isAutomaticDispenser = false;
  String dispenserType = '';
  String dispenserBrandName = '';
  if(isDispenser){
    dispenserBrandName = listedItems['brandName'] == ' ' ? '' : listedItems['brandName'];
    isAutomaticDispenser = listedItems['isDispenserAutomatic'];
   if(isAutomaticDispenser) {
     dispenserType = '(Automatic)';
   } else {
     dispenserType = '(Manual Jar)';
   }
  }
  bool isInPack = listedItems['isInPack'];



  return Card(
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      padding: const EdgeInsets.only(top: 20, bottom: 10, right: 0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.27,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(image: CachedNetworkImageProvider(imageLink), fit: BoxFit.contain)
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.63,
                  height: 25,
                  child: RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(children: [
                      TextSpan(
                          text: "₹ ",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: price,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500))
                    ]),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  isDispenser ? dispenserBrandName + ' Dispenser\n' +  dispenserType : productName + ' ' + isChilled,
                  style: TextStyle(
                    fontSize: isDispenser ? 15 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 8),
              isInPack ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                  "A pack of " + listedItems['bottlesPerPack'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ) : Container(),
              const SizedBox(height: 8),
              !isDispenser ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                  "In Stock: " + stock.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ) : Container(),
              const SizedBox(height: 8),
              !isDispenser ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Text(
                   listedItems['type'] == 'Water Bottle'  || listedItems['isGeneralProduct'] ? "Item Quantity: " + quantity.toString(): "Item Quantity: " + quantity.toString() + "L",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ) : Container(),
              const SizedBox(height: 10),
              !isDispenser ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "View More",
                      style: TextStyle(color: primaryColor),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        size: 12,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              ) : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Edit Details",
                      style: TextStyle(color: primaryColor),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    child: Center(
                      child: Icon(
                        Icons.edit,
                        size: 14,
                        color: primaryColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ),
  );
}

Widget customStatsCard(height, width, text, number) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: width,
            //   height: height * 0.6,
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          Container(
            width: width,
            //  height: height * 0.5,
            child: Text(
              number,
              style: TextStyle(
                color: primaryColor,
                fontSize: 35,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget vehicleCard(height, width, vehicleUrl, name) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: width * 0.3,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(vehicleUrl)),
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              width: 40,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        )),
  );
}

Widget noDataDashboard(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/no_data.png'),
                fit: BoxFit.fill)),
      ),
      SizedBox(
        height: 30,
      ),
      Text(
        'No data available',
        style: TextStyle(
            fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600),
      )
    ],
  );
}

Widget nextButton() {
  return Padding(
    padding: const EdgeInsets.only(right: 4),
    child: Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "NEXT ",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}

Widget customOrdersCard(
    context, Map<String, dynamic> urgentOrders, showUrgentTag) {
  String? name = urgentOrders['userId']['name'];
  String? phoneNo = urgentOrders['userId']['phone'].toString();
  String? amount = urgentOrders['finalPaymentAmount'].toString();
  bool isPaid = urgentOrders['paymentStatus'] == 'PENDING' ? false : true;
  String? orderId = urgentOrders['orderId'] ?? 'XXXXXX';

  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CompleteOrderDetails(orderDetails: urgentOrders)));
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showUrgentTag
                  ? Container(
                      height: 20,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        color: Color.fromRGBO(190, 0, 0, 1),
                      ),
                      child: const Center(
                        child: Text(
                          'URGENT',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  : Container(),
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
                            fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        phoneNo,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            amount,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View Complete Order',
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
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 65,
                  height: 33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isPaid
                        ? Color.fromRGBO(6, 154, 0, 1.0)
                        : Color.fromRGBO(248, 182, 76, 1),
                  ),
                  child: Center(
                    child: Text(
                      isPaid ? 'PAID' : 'COD',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'ORDER ID: ' + orderId!,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget customOrdersReceivedCard(context, Map<String, dynamic> ordersReceived) {
  HelperFunctions helperFunctions = HelperFunctions();
  SaveData saveData = new SaveData();
  //print(ordersReceived);
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
  String summarizedCart = helperFunctions.summarizeCart(orders);
  String deliveryBoyName = ordersReceived['deliveryBoyId'] == null ? 'Self' : ordersReceived['deliveryBoyId']['name'];
  String paymentType = ordersReceived['paymentType'];

  return Stack(
    alignment: Alignment.topRight,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CompleteOrderDetails(orderDetails: ordersReceived, deliveryBoyName: deliveryBoyName,)));
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
                                width: MediaQuery.of(context).size.width * 0.12,
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
                                              orderDetails: ordersReceived)));
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

Widget customOrdersCancelledCard(context, Map<String, dynamic> ordersReceived) {
  HelperFunctions helperFunctions = HelperFunctions();
  SaveData saveData = new SaveData();
  //print(ordersReceived);
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
  String summarizedCart = helperFunctions.summarizeCart(orders);
  String deliveryBoyName = ordersReceived['deliveryBoyId'] == null ? 'Self' : ordersReceived['deliveryBoyId']['name'];
  String paymentType = ordersReceived['paymentType'];

  return Stack(
    alignment: Alignment.topRight,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CompleteOrderDetails(orderDetails: ordersReceived, deliveryBoyName: deliveryBoyName,)));
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
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  color: Color.fromRGBO(134, 134, 134, 1)
                ),
                child: const Center(
                  child: Text(
                    'Cancelled',
                    style: TextStyle(
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
                        width: MediaQuery.of(context).size.width,
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

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
                                              orderDetails: ordersReceived)));
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

Widget customOrdersByParticularCustomer(
    context, ordersReceived, name, phoneNo) {
  HelperFunctions helperFunctions = HelperFunctions();
  String? orderId = ordersReceived['orderId'];
  String? amount = ordersReceived['finalPaymentAmount'].toString();
  bool isDelivered = ordersReceived['status'] == 'DELIVERED' ? true : false;
  String? orderCart = helperFunctions.summarizeCart(ordersReceived['products']);
  bool isPaid = ordersReceived['paymentStatus'] == 'PENDING' ? false : true;

  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CompleteOrderDetails(
                    orderDetails: ordersReceived,
                    name: name,
                    phoneNo: phoneNo,
                  )));
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 23,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  color: isDelivered
                      ? const Color.fromRGBO(6, 154, 0, 1.0)
                      : Color.fromRGBO(248, 182, 76, 1),
                ),
                child: Center(
                  child: Text(
                    isDelivered ? 'Delivered' : 'Pending',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5, left: 15, right: 15, top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          orderCart,
                          style: const TextStyle(
                              color: Color.fromRGBO(151, 151, 151, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
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
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View Complete Order',
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
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 65,
                  height: 33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isPaid
                        ? Color.fromRGBO(6, 154, 0, 1.0)
                        : Color.fromRGBO(248, 182, 76, 1),
                  ),
                  child: Center(
                    child: Text(
                      isPaid ? 'PAID' : 'COD',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'ORDER ID: ' + orderId!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget listDashedLines() {
  return Column(
    children: [
      Icon(
        CupertinoIcons.stop_circle_fill,
        color: primaryColor,
        size: 18,
      ),
      Container(
        height: 2,
        width: 2,
        color: primaryColor,
      ),
      const SizedBox(
        height: 4,
      ),
      Container(
        height: 5,
        width: 2,
        color: primaryColor,
      ),
      const SizedBox(
        height: 3,
      ),
      Container(
        height: 5,
        width: 2,
        color: primaryColor,
      ),
      const SizedBox(
        height: 4,
      ),
      Container(
        height: 5,
        width: 2,
        color: primaryColor,
      ),
      const SizedBox(
        height: 3,
      ),
      Container(
        height: 2,
        width: 2,
        color: primaryColor,
      ),
    ],
  );
}

Widget customOrdersDeliveredCard(
    context, Map<String, dynamic> ordersDelivered, deliveryBoyName) {
  HelperFunctions helperFunctions = HelperFunctions();
  SaveData saveData = SaveData();
  String name = ordersDelivered['userId']['name'];
  String orderId = ordersDelivered['orderId'];
  String orderCart = helperFunctions.summarizeCart(ordersDelivered['products']);
  String orderDate = ordersDelivered['createdAt'].toString().substring(0, 10);
  orderDate = helperFunctions.formatDate(orderDate);
  String startingLocation = Constants.myShortAddress;
  String endingLocation =
      saveData.fetchShortAddressFromMap(ordersDelivered['deliveryAddress']);
  String startingTime =
      ordersDelivered['createdAt'].toString().substring(11, 16);
  startingTime = helperFunctions.parseDateTime(startingTime, true);
  String endingTime = ordersDelivered['deliveryTime'].toString().substring(11, 16);
  endingTime = helperFunctions.parseDateTime(endingTime, true);
  String amount = ordersDelivered['finalPaymentAmount'].toString();

  print('!!!!!!!!!!');

  return GestureDetector(
    onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CompleteOrderDetails(orderDetails: ordersDelivered, name: name, phoneNo: ordersDelivered['userId']['phone'].toString(), deliveryBoyName: deliveryBoyName,)));
    },
    child: Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ' + name,
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Order Id: ' + orderId,
                  style:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    orderCart,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(131, 131, 131, 1)),
                    overflow: TextOverflow.ellipsis,
                  ),

                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  orderDate,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(131, 131, 131, 1)),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(
                          CupertinoIcons.stop_circle_fill,
                          color: primaryColor,
                          size: 18,
                        ),
                        Container(
                          height: 35,
                          width: 2,
                          color: primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            startingLocation,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                            maxLines: 2,
                          ),
                        ),
                        const Text(
                           '',// startingTime,
                          style: const TextStyle(
                              color: Color.fromRGBO(131, 131, 131, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.stop_circle_fill,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          endingLocation,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                        const Text(
                          '',//endingTime,
                          style: TextStyle(
                              color: Color.fromRGBO(131, 131, 131, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: [
              TextSpan(
                  text: "₹ ",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
              TextSpan(
                  text: amount,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500))
            ]),
          ),
        )
      ],
    ),
  );
}

Widget notificationCard(context, notification){
  String title = notification['title'];
  String msg = notification['body'];
  print(title + '.');
  print(msg);
  IconData notificationIcon;
  Color iconColor;
  if(title == 'Urgent order') {
    notificationIcon = Icons.access_time_filled;
    iconColor = Colors.red;
  }
  else if(title == 'Bad review'){
    notificationIcon = Icons.mood_bad_outlined;
    iconColor = Colors.orangeAccent;
  }
  else if(title == 'Congratulations!'){
    notificationIcon = Icons.delivery_dining;
    iconColor = Colors.purple;
  }
  else if(title == 'IndieWater'){
    notificationIcon = Icons.person;
    iconColor = primaryColor;
  }
  else if(title == 'Delivery boy unavailable '){
    notificationIcon = Icons.cancel_rounded;
    iconColor = Colors.green;
  }
  else{
    notificationIcon = Icons.notifications;
    iconColor = Colors.brown;
  }
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
         // height: 80,
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.only(left: 8, top: 15, bottom: 15),
          child: Text(msg, overflow: TextOverflow.ellipsis, maxLines: 3, style: TextStyle(fontSize: 17),),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Icon(
            notificationIcon,
            color: iconColor,
            size: 28,
          ),
        )
      ],
    ),
  );
}
