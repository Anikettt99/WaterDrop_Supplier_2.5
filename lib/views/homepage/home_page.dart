import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/homepage/add_delivery_boy.dart';
import 'package:waterdrop_supplier/views/homepage/dashboard.dart';
import 'package:waterdrop_supplier/views/homepage/statistics.dart';
import 'package:waterdrop_supplier/views/homepage/profile.dart';

import 'listed_items.dart';

class HomePage extends StatefulWidget {
  int index;
  int dashBoardIndex;
  bool getUserData;

  HomePage({Key? key, this.index = 2, this.dashBoardIndex = 1, this.getUserData = true})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentIndex;
  bool showAppBar = false;
  late int dashBoardIndex;

  @override
  void initState() {
    print(widget.index);
    if(widget.getUserData) {
      getUserInfo();
    }
    // TODO: implement initState
    setState(() {
      currentIndex = widget.index;
      dashBoardIndex = widget.dashBoardIndex;
    });
  }

  getUserInfo() async {
    Constants.deliveryBoyDetailsDateTime = DateTime.now();
    Constants.customerInfoDateTime = DateTime.now();
    Constants.orderReceivedDateTime = DateTime.now();
    Constants.myLocationId =
        (await HelperFunctions.getLocationIdSharedPreference())!;
    Constants.myToken = (await HelperFunctions.getUserTokenSharedPreference())!;
    Constants.myPhoneNumber =
        (await HelperFunctions.getPhoneNumberSharedPreference())!;
    Constants.myMail = (await HelperFunctions.getUserMailIdSharedPreference())!;
    //Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    Constants.myStoreName =
        (await HelperFunctions.getStoreNameSharedPreference())!;
    Constants.myCode = (await HelperFunctions.getUserCodeSharedPreference())!;
    Constants.qrCodeLink =
        (await HelperFunctions.getUserQrCodeLinkSharedPreference())!;
    Constants.myAddress =
        (await HelperFunctions.getUserAddressSharedPreference())!;
    Constants.myShortAddress =
        (await HelperFunctions.getUserShortAddressSharedPreference())!;
    Constants.mySupplierId =
        (await HelperFunctions.getSupplierIdSharedPreference())!;
    Constants.slot1StartTime =
        (await HelperFunctions.getUserSlot1StartTimeSharedPreference())!;
    Constants.slot1EndTime =
        (await HelperFunctions.getUserSlot1EndTimeSharedPreference())!;
    Constants.slot2StartTime =
        (await HelperFunctions.getUserSlot2StartTimeSharedPreference())!;
    Constants.slot2EndTime =
        (await HelperFunctions.getUserSlot2EndTimeSharedPreference())!;
    Constants.securityDepositAmount =
        (await HelperFunctions.getSecurityDepositAmountSharedPreference())!;
    Constants.myAadharNumber =
        (await HelperFunctions.getAadharCardNumberSharedPreference())!;
    Constants.myPanCardNumber =
        (await HelperFunctions.getPanCardNumberSharedPreference())!;
    Constants.myGSTNumber =
        (await HelperFunctions.getGSTNumberSharedPreference())!;
    Constants.headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Constants.myToken,
    };
    Constants.fastDeliveryCharges =
        (await HelperFunctions.getFastDeliveryChargeSharedPreference())!;
    print(Constants.headersMap);
  }

  final List pages = [
    const ListedItems(),
    const Statistics(),
    Dashboard(),
    const AddDeliveryBoy(),
    const ProfileHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: currentIndex == 2
          ? Dashboard(index: dashBoardIndex)
          : pages[currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.35),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.25),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.15),
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.00),
          ],
        )),
        child: CurvedNavigationBar(
          index: currentIndex,
          animationDuration: const Duration(milliseconds: 400),
          height: 60,
          buttonBackgroundColor: primaryColor,
          backgroundColor: Colors.transparent,
          color: Colors.white,
          items: <Widget>[
            RotatedBox(
              quarterTurns: 2,
              child: Icon(
                currentIndex == 0
                    ? Icons.add_location
                    : Icons.add_location_outlined,
                size: 25,
                color: currentIndex == 0 ? Colors.white : Colors.black,
              ),
            ),
            Icon(
              currentIndex == 1
                  ? CupertinoIcons.chart_bar_fill
                  : CupertinoIcons.chart_bar,
              size: 26,
              color: currentIndex == 1 ? Colors.white : Colors.black,
            ),
            Icon(
              currentIndex == 2
                  ? Icons.dashboard_rounded
                  : Icons.dashboard_outlined,
              size: 25,
              color: currentIndex == 2 ? Colors.white : Colors.black,
            ),
            Icon(
              currentIndex == 3
                  ? Icons.delivery_dining
                  : Icons.delivery_dining_outlined,
              size: 25,
              color: currentIndex == 3 ? Colors.white : Colors.black,
            ),
            Icon(
              currentIndex == 4 ? Icons.person : Icons.person_outline,
              size: 26,
              color: currentIndex == 4 ? Colors.white : Colors.black,
            ),
          ],
          onTap: (index) {
            print(index);
            dashBoardIndex = 1;

            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
