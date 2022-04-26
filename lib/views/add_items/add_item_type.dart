import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/add_items/add_dispenser_details.dart';
import 'package:waterdrop_supplier/views/add_items/add_general_items.dart';
import 'package:waterdrop_supplier/views/add_items/add_thermal_water_can_details.dart';
import 'package:waterdrop_supplier/views/add_items/add_water_bottle_details.dart';
import 'package:waterdrop_supplier/views/add_items/add_water_can_details.dart';

class AddItemType extends StatefulWidget {
  const AddItemType({Key? key}) : super(key: key);

  @override
  _AddItemTypeState createState() => _AddItemTypeState();
}

class _AddItemTypeState extends State<AddItemType> {
  Widget customRow(itemImage, itemName, callBackFn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.asset(itemImage),
              ),
              Text(
                itemName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                ),
              )
            ],
          ),
          Material(
            borderRadius: BorderRadius.circular(50),
            color: primaryColor,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.blue.shade900,
              onTap: () {
                callBackFn();
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.28,
                padding: EdgeInsets.all(10),
                child: const Center(
                  child: Text(
                    'ADD ITEM',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.back),
            color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Select Item Type",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customRow('assets/manual_dispenser.png', 'Dispenser', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddDispenserDetails()));
          }),
          const Divider(
            thickness: 5,
          ),
          customRow('assets/bottle.png', 'Water Bottle', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddWaterBottleDetails()));
          }),
          const Divider(
            thickness: 5,
          ),
          customRow('assets/can.png', 'Water Can', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddWaterCanDetails()));
          }),
          const Divider(
            thickness: 5,
          ),
          customRow('assets/thermal_can.png', 'Thermal Can', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddThermalWaterCanDetails()));
          }),
          const Divider(
            thickness: 5,
          ),
          customRow('assets/general_items.png', 'General Items', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddGeneralItems()));
          }),
        ],
      ),
    );
  }
}
