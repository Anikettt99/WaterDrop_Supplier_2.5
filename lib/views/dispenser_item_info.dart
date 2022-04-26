/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/edit_items/edit_dispenser_details.dart';

class DispenserItemInfo extends StatefulWidget {
  Map<String, dynamic> itemDetails;
  String productName;

  DispenserItemInfo({Key? key, required this.itemDetails, required this.productName})
      : super(key: key);

  @override
  _DispenserInfoState createState() => _DispenserInfoState();
}

class _DispenserInfoState extends State<DispenserItemInfo> {
  Map<String, dynamic> itemInfo = {};

  @override
  void initState() {
    itemInfo = widget.itemDetails;
    print(itemInfo);
    // TODO: implement initState
    super.initState();
  }

  Widget itemContainer() {
    String price = itemInfo['unitPrice'].toString();
    String productName =
        itemInfo['brandName'];
    final width = MediaQuery.of(context).size.width;
    bool isAutomaticDispenser = false;
    String dispenserType = '';
    isAutomaticDispenser = itemInfo['isDispenserAutomatic'];
    if(isAutomaticDispenser)
      dispenserType = 'Automatic Pump Dispenser';
    else
      dispenserType = 'Manual Jar Dispenser';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      height: MediaQuery.of(context).size.height * 0.50,
      width: width,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 5,
                offset: Offset(0, 0))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.6,
                child: Text(
                  productName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5
                  ),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: primaryColor,

                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditDispenserDetails(details: itemInfo)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(Icons.edit, color: Colors.white,size: 20,),
                    SizedBox(width: 5,),
                    Text('Edit', style: TextStyle(
                        color: Colors.white
                    ),)
                  ],
                ),

              )
            ],
          ),
          Text(
            dispenserType,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Text(
              'Price',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400
              ),
            ),
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(children: [
                TextSpan(
                    text: "₹ ",
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: price,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold))
              ]),
            ),
          ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Item Information',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: SvgPicture.asset('assets/chilled_water.svg', height: MediaQuery.of(context).size.height * 0.28,),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
            ),
            itemContainer(),
          ],
        ),
      ),
    );
  }
}
*/
