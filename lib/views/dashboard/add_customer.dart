// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';
import 'package:waterdrop_supplier/views/notifications.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  TextEditingController password_controller_org = TextEditingController();
  TextEditingController password_controller_con = TextEditingController();
  TextEditingController NameController = TextEditingController();
  TextEditingController PhoneNoController = TextEditingController();
  Color textColor = Color(0XFF868686);
  bool controller = true;
  // DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool isSigning = false;
  DataBaseMethods dataBaseMethods = new DataBaseMethods();

  IconData password_icon(controller) {
    if (controller == false) {
      return CupertinoIcons.eye;
    } else {
      return CupertinoIcons.eye_slash;
    }
  }

  bool cnfPassword = true;
  Color confirm_password_field = Colors.red;
  bool rememberMe = false;

  addCustomer() {
    setState(() {
      isSigning = true;
    });
    Map<String, dynamic> customerDetails = {
      "name": NameController.text,
      "phone": PhoneNoController.text,
      "password": password_controller_org.text,
      "confirmPassword": password_controller_con.text,
      "locationCode": Constants.myCode,
      "countryCode": "+91"
    };
    dataBaseMethods.addCustomer(customerDetails).then((value) {
      if (value == true) {
        setState(() {
          isSigning = false;
        });
        dataBaseMethods.showToastNotification("Requested Successfully");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      index: 2,
                    )));
      }
      setState(() {
        isSigning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              icon: Icon(
                Icons.notifications_none,
                size: 29,
              ))
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                controller: NameController,
                // style: TextStyle(color: textColor),
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: textColor)),
                  labelText: 'NAME',
                  labelStyle: TextStyle(fontSize: 12, letterSpacing: 1.0),
                ),
                keyboardType: TextInputType.name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Z ,a-z]+')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: PhoneNoController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'MOBILE NUMBER',
                  prefixText: '+91 | ',
                  hoverColor: Colors.blue,
                  counterText: "",
                  labelStyle: TextStyle(fontSize: 12, letterSpacing: 1.0),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              isSigning == true
                  ? ElevatedButton(
                      child: CircularProgressIndicator(),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Color(0xff006BFF)),
                      onPressed: () {
                        // SignMeUp();
                      },
                    )
                  : ElevatedButton(
                      child: Text(
                        "ADD",
                        style: TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color(0xff006BFF)),
                      onPressed: () {
                        addCustomer();
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
