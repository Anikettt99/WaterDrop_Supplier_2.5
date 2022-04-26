// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/dashboard/cancelled_orders.dart';
import 'package:waterdrop_supplier/views/dashboard/customer_info.dart';
import 'package:waterdrop_supplier/views/dashboard/delivered.dart';
import 'package:waterdrop_supplier/views/dashboard/not_delivered.dart';
import 'package:waterdrop_supplier/views/dashboard/order_received.dart';
import 'package:waterdrop_supplier/views/dashboard/urgent_delivery.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:waterdrop_supplier/views/view_qr_code.dart';
import '../notifications.dart';

class Dashboard extends StatefulWidget {
  int index;
  Dashboard({Key? key, this.index = 1}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int? currentIndex;
  final List pages = const [
    CustomerInfo(),
    OrderReceived(),
    UrgentDelivery(),
    Delivered(),
    CancelledOrders(),
  ];

  //Customer Info, OrderReceieved, UrgentDelivery, Delivered, Not Delivered

  @override
  void initState() {
    currentIndex = widget.index;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: currentIndex!,
      length: pages.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Dashboard',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()));
              },
              child: const Padding(
                padding: const EdgeInsets.only(left: 8, right: 12),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ViewQrCode()));
            },
            child: Icon(Icons.qr_code),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: TabBar(
              physics: BouncingScrollPhysics(),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              indicator: DotIndicator(
                color: Colors.white,
                distanceFromCenter: 16,
                radius: 3,
                paintingStyle: PaintingStyle.fill,
              ),
              isScrollable: true,
              labelColor: Colors.white,
              tabs: const [
                Tab(
                  text: 'Customer Info',
                ),
                Tab(text: 'Order Received'),
                Tab(text: 'Urgent Orders'),
                Tab(text: 'Delivered Orders'),
                Tab(text: 'Cancelled Orders'),
              ],
            ),
          ),
          // leading: Icon(
          //   Icons.arrow_back,
          //   color: Colors.black,
          // ),
        ),

        body: const TabBarView(
          children: [
            CustomerInfo(),
            OrderReceived(),
            UrgentDelivery(),
            Delivered(),
            CancelledOrders(),
          ],
        ),

        // body: Column(
        //   children: [
        //     SizedBox(
        //         height: 40,
        //         child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: _pages.length,
        //             itemBuilder: (context, index) {
        //               return Row(
        //                 children: [
        //                   SizedBox(
        //                     width: 8,
        //                   ),
        //                   // buildBTN(
        //                   //   context,
        //                   //   100,
        //                   //   15,
        //                   //   () {
        //                   //     _selected = index;
        //                   //     page = _pages[index];
        //                   //     setState(() {});
        //                   //   },
        //                   //   _selected == index ? Colors.black : Colors.green,
        //                   //   Colors.white,
        //                   //   Colors.black,
        //                   //   _headers[index].toString(),
        //                   // ),
        //                   GestureDetector(
        //                       onTap: () {
        //                         _selected = index;
        //                         page = _pages[index];
        //                         setState(() {});
        //                       },
        //                       child: Container(
        //                         height: 30,
        //                         decoration: BoxDecoration(
        //                           boxShadow: [
        //                             BoxShadow(
        //                               color: Colors.grey.withOpacity(0.5),
        //                               spreadRadius: 2,
        //                               blurRadius: 3,
        //                               // offset: Offset(
        //                               //     0, 3), // changes position of shadow
        //                             ),
        //                           ],
        //                           borderRadius:
        //                               BorderRadius.all(Radius.circular(5)),
        //                           color: _selected == index
        //                               ? primaryColor
        //                               : Colors.white,
        //                         ),
        //                         child: Padding(
        //                           padding: const EdgeInsets.symmetric(
        //                               horizontal: 8, vertical: 6),
        //                           child: Text(
        //                             _headers[index],
        //                             style: TextStyle(
        //                                 color: _selected == index
        //                                     ? Colors.white
        //                                     : Colors.black),
        //                           ),
        //                         ),
        //                       )),
        //                   SizedBox(
        //                     width: 8,
        //                   ),
        //                 ],
        //               );
        //             })),
        //     Expanded(
        //       child: ListView(
        //         shrinkWrap: true,
        //         physics: ScrollPhysics(),
        //         children: [page],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
