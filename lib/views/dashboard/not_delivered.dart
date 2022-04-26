import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

class NotDelivered extends StatefulWidget {
  const NotDelivered({Key? key}) : super(key: key);

  @override
  _NotDeliveredState createState() => _NotDeliveredState();
}

class _NotDeliveredState extends State<NotDelivered> {
  List<Map<String, dynamic>> notDeliveredOrders = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    dataBaseMethods.fetchNotDeliveredOrders().then((value) {
      setState(() {
        notDeliveredOrders = value;
        print(notDeliveredOrders);
        /*notDeliveredOrders = [
          {
            'name': 'Pranjal',
            'phoneNo': '+91 9022807560',
            'orderId': '123456',
            'amount': '500',
            'paidStatus': 'cod',
            'deliveryStatus': 'not delivered',
            'orderCart': '1x1 L water bottle, 1x10L can',
            'address': '06 Medical Lane , dum dum, kolkata',
            'receiveTime': '12-01-2022, 3:45 PM',
            'deliveryTime': '12-01-2022, 6:45 PM'
          },
          {
            'name': 'Rohit',
            'phoneNo': '+91 9022807560',
            'orderId': '123476',
            'amount': '200',
            'paidStatus': 'cod',
            'deliveryStatus': 'not delivered',
            'orderCart': '1x1 L water bottle, 1x10L can',
            'address': '06 Medical Lane , dum dum, kolkata',
            'receiveTime': '15-01-2022, 1:23 PM',
            'deliveryTime': ''
          },
          {
            'name': 'Pranjal',
            'phoneNo': '+91 9022807560',
            'orderId': '123456',
            'amount': '500',
            'paidStatus': 'cod',
            'deliveryStatus': 'not delivered',
            'orderCart': '1x1 L water bottle, 1x10L can',
            'address': '06 Medical Lane , dum dum, kolkata',
            'receiveTime': '15-01-2022, 1:23 PM',
            'deliveryTime': '16-01-2022, 10:45 AM'
          },
          {
            'name': 'Rohit',
            'phoneNo': '+91 9022807560',
            'orderId': '123476',
            'amount': '200',
            'paidStatus': 'cod',
            'deliveryStatus': 'not delivered',
            'orderCart': '1x1 L water bottle, 1x10L can',
            'address': '06 Medical Lane , dum dum, kolkata',
            'receiveTime': '15-01-2022, 1:23 PM',
            'deliveryTime': ''
          },
          {
            'name': 'Pranjal',
            'phoneNo': '+91 9022807560',
            'orderId': '123456',
            'amount': '500',
            'paidStatus': 'cod',
            'deliveryStatus': 'not delivered',
            'orderCart': '1x1 L water bottle, 1x10L can',
            'address': '06 Medical Lane , dum dum, kolkata',
            'receiveTime': '15-01-2022, 1:23 PM',
            'deliveryTime': '16-01-2022, 10:45 AM'
          },
          {
            'name': 'Rohit',
            'phoneNo': '+91 9022807560',
            'orderId': '123476',
            'amount': '200',
            'paidStatus': 'cod',
            'deliveryStatus': 'not delivered',
            'orderCart': '1x1 L water bottle, 1x10L can',
            'address': '06 Medical Lane , dum dum, kolkata',
            'receiveTime': '15-01-2022, 1:23 PM',
            'deliveryTime': ''
          },
        ];*/
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: CircularProgressIndicator(color: primaryColor,)))
        : notDeliveredOrders.length == 0
            ? Center(child: noDataDashboard(context))
            : ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 15),
                    child: Center(
                      child: Text(
                        "Total Orders Not Delivered : 100",
                        style: TextStyle(color: secondaryColor, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notDeliveredOrders.length,
                      itemBuilder: (BuildContext context, index) {
                        return customOrdersCard(
                            context, notDeliveredOrders[index], false);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 0);
                      },
                    ),
                  ),
                ],
              );
  }
}
