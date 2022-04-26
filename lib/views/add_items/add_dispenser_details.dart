import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

import '../homepage/listed_items.dart';

class AddDispenserDetails extends StatefulWidget {
  const AddDispenserDetails({Key? key}) : super(key: key);

  @override
  _AddDispenserDetailsState createState() => _AddDispenserDetailsState();
}

class _AddDispenserDetailsState extends State<AddDispenserDetails> {
  int isWhite = 1;
  int isJar = 1;
  TextEditingController brandName = TextEditingController();
  TextEditingController price = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Add Item Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ADD DISPENSER DETAILS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: brandName,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Brand Name (Optional)",
                      labelStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]+')),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: TextButton(
                        onPressed: () {},
                        child: Text(
                          '₹  |',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: height / 40),
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                    ],
                    validator: (name) {
                      if (name!.length == 0) {
                        return 'Required';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Is it a jar or automatic pump dispenser?',
                    style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1), fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Radio(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                groupValue: isJar,
                                value: 1,
                                onChanged: (value) {
                                  setState(() {
                                    isJar = 1;
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                              const Text(
                                'Jar',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/manual_dispenser.png'
                                    )
                                )
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(

                            children: [
                              Radio(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                groupValue: isJar,
                                value: 0,
                                onChanged: (value) {
                                  setState(() {
                                    isJar = 0;
                                  });
                                },
                                activeColor: primaryColor,
                              ),
                              const Text(
                                'Automatic pump dispenser',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/auto_dispenser.png'
                                    )
                                )
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          loading ? Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 3,
            child: Container(
              padding: EdgeInsets.all(12),
              width: width * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  const Text(
                      'Adding Item',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),
                  )
                ],
              ),
            ),
          ) : Container()
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: width / 3,
              height: height / 15,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    "GO BACK",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: width / 23,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width / 3,
              height: height / 15,
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                color: primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: FlatButton(
                onPressed: loading ? null : () async {
                  if(_formKey.currentState!.validate()){
                    if(int.parse(price.text) == 0){
                      dataBaseMethods.showToastNotification('Price can not be zero');
                      return;
                    }
                    Map<String, dynamic> itemDetails = {
                      'brandName': brandName.text == null || brandName.text == '' ? ' ' : brandName.text,
                      'unitPrice': price.text,
                      'isDispenser': true,
                      'imageLink': 'hello.com',
                      'supplierId': Constants.mySupplierId,
                      'locationId': Constants.myLocationId,
                      'type': 'Dispenser',
                      'isDispenserAutomatic': isJar == 1 ? false : true
                    };
                    Map<String, dynamic> newItemDetails = {};
                    setState(() {
                      loading = true;
                    });
                    await dataBaseMethods.addItem(itemDetails).then((value) {
                      newItemDetails = value;
                    });
                    dataBaseMethods.showToastNotification('Sucessfully Added Item');
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                    Navigator.pop(context, newItemDetails);
                  }
                },
                child: Center(
                  child: Text(
                    "ADD ITEM",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width / 23,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
