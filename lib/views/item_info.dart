import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/edit_items/edit_general_details.dart';
import 'package:waterdrop_supplier/views/edit_items/edit_water_bottle_details.dart';

import 'edit_items/edit_water_can_details.dart';

class ItemInfo extends StatefulWidget {
  Map<String, dynamic> itemDetails;
  String productName;

  ItemInfo({Key? key, required this.itemDetails, required this.productName})
      : super(key: key);

  @override
  _ItemInfoState createState() => _ItemInfoState();
}

class _ItemInfoState extends State<ItemInfo> {
  Map<String, dynamic> itemInfo = {};
  String imageName = '', imageLink = '';
  HelperFunctions helperFunctions = HelperFunctions();

  @override
  void initState() {
    itemInfo = widget.itemDetails;
    imageLink = widget.itemDetails['imageLink'];
    imageName = helperFunctions.getImageName(itemInfo['brandName'], itemInfo['type'], itemInfo['isWaterChilled'], itemInfo['isInPack']);
    print(itemInfo);
    // TODO: implement initState
    super.initState();
  }

  Widget itemContainer() {
    String price = itemInfo['unitPrice'].toString();
    String quantity = itemInfo['qtyInLiters'].toString();
    String itemType = itemInfo['type'];
    String productName = helperFunctions.getItemName(itemInfo);
    String stock = itemInfo['quantityAvailable'].toString();
    String isChilled =
        itemInfo['isWaterChilled'] == null || !itemInfo['isWaterChilled']
            ? ''
            : '(Chilled)';
    final width = MediaQuery.of(context).size.width;
    String fromFloor =  itemInfo['fromFloor'] == null ? '0' : itemInfo['fromFloor'].toString();
    String floorCharges = itemInfo['floorCharges'] == null ? '0' : itemInfo['floorCharges'].toString();
    bool isInPack = itemInfo['isInPack'];

    print(productName);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      height: MediaQuery.of(context).size.height * 0.5,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.6,
                child: Text(
                  isInPack ? productName + ' ' + isChilled + '\nA Pack of ' + itemInfo['bottlesPerPack'].toString() : productName + ' ' + isChilled,
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
                  print(itemType);
                  if(itemInfo['isGeneralProduct']!=null && itemInfo['isGeneralProduct']){
                    print('!!!!!!!!1');
                    print(itemInfo);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGeneralItems(details: itemInfo)));
                  }
                  else if(itemType == 'Water Bottle'){
                    print('Water Bottle');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditWaterBottleDetails(details: itemInfo)));
                  }
                  else {
                    print('Water Bottle');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditWaterCanDetails(details: itemInfo)));
                  }
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Text(
                  itemType == 'Water Bottle' || itemInfo['isGeneralProduct'] ? quantity : quantity + 'L',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                    'Item',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
                const Text(
                  'Quantity',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
              ),
              Column(children: [
                Text(
                  stock + ' Units',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Text(
                  'Stock',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
                const Text(
                  'Available',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
              ),
              Column(children: [
                RichText(
                textAlign: TextAlign.right,
                text: TextSpan(children: [
                  TextSpan(
                      text: "₹ ",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: price,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold))
                ]),
              ),

                const Text(
                  'Price',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.6,
                child: Text(
                  'Delivery Charge From Floor Number ' + fromFloor,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(children: [
                  TextSpan(
                      text: "₹ ",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: floorCharges,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 25,
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /*Center(
              child: SvgPicture.asset('assets/chilled_water.svg', height: MediaQuery.of(context).size.height * 0.28,),
            ),*/
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.37,
              decoration: BoxDecoration(
                  image: imageLink == null || imageLink == '' || imageLink == 'hello.com' ? DecorationImage(
                      image: AssetImage(imageName) ,
                      fit: BoxFit.fill
                  ): DecorationImage(image: CachedNetworkImageProvider(imageLink), fit: BoxFit.contain)
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            itemContainer(),
          ],
        ),
      ),
    );
  }
}
