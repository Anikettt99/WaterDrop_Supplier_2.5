import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

class DeliveryBoyForm extends StatefulWidget {
  const DeliveryBoyForm({Key? key}) : super(key: key);

  @override
  _DeliveryBoyFormState createState() => _DeliveryBoyFormState();
}

class _DeliveryBoyFormState extends State<DeliveryBoyForm> {
  int genderVal = 0;
  bool hidePassword = true, hideConfirmPassword = true;
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  Map<String, dynamic> newDeliveryBoyDetails = {};
  final _formKey = GlobalKey<FormState>();
  bool isDeliveryBoyAdding = false;
  bool success = true;

  addNewDeliveryBoy() async {
    Map<String, dynamic> deliveryBoyDetailsMap = {
      'name' : nameTextEditingController.text,
      'phone' : phoneTextEditingController.text,
      'password': passwordTextEditingController.text,
      'address': addressTextEditingController.text,
      'confirmPassword': confirmPasswordTextEditingController.text,
      'employerId': Constants.mySupplierId,
      'locationId': Constants.myLocationId,
      'available': true,
    };
    success =  await dataBaseMethods.addDeliveryBoy(deliveryBoyDetailsMap);
    print(success);
    newDeliveryBoyDetails = deliveryBoyDetailsMap;
  }

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
          color: Colors.black,
        ),
        centerTitle: true,
        title: const Text(
          "Delivery Partner",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Add new Delivery Partner',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                   // const SizedBox(height: 2),

                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 6,
                          ),
                          TextFormField(
                            controller: nameTextEditingController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Full Name",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (val){
                              if(val!.length == 0) {
                                return 'Required';
                              }
                              if(val.length >= 20) {
                                return 'Name cant be more than 20 characters';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]+'))],
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: phoneTextEditingController,
                            decoration: InputDecoration(

                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Mobile Number",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: TextButton(
                                onPressed: () {},
                                child: Text(
                                  '+91',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                                ),
                              ),
                            ),
                            validator: (val){
                              if(val!.length == 0)
                                return 'Required';
                              if(val.length != 10){
                                return 'Invalid Phone Number';
                              }
                              return null;
                            },
                              inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]+'))],
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          TextFormField(
                           // expands: true,
                            controller: addressTextEditingController,
                            maxLines: null,
                            minLines: null,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Full Address",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (val){
                              if(val!.length == 0)
                                return 'Required';
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          TextFormField(
                            controller: passwordTextEditingController,
                            obscureText: hidePassword,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      hidePassword = !hidePassword;
                                      setState(() {});
                                    },
                                    child: !hidePassword
                                        ? const Icon(CupertinoIcons.eye_slash_fill)
                                        : const Icon(CupertinoIcons.eye_fill)),
                              ),
                            ),
                            validator: (val) {
                              return val!.length <= 7
                                  ? 'Password must be of minimum 8 characters'
                                  : null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: confirmPasswordTextEditingController,
                            obscureText: hideConfirmPassword,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      hideConfirmPassword = !hideConfirmPassword;
                                      setState(() {});
                                    },
                                    child: !hideConfirmPassword
                                        ? const Icon(CupertinoIcons.eye_slash_fill)
                                        : const Icon(CupertinoIcons.eye_fill)),
                              ),
                            ),
                            validator: (val){
                              return val == passwordTextEditingController.text
                                  ? null
                                  : 'Password didn\'t match';
                            },
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          height: height / 15,
                          decoration: BoxDecoration(
                            border: Border.all(color: secondaryColor),
                            color: primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: InkWell(
                            onTap: () async {
                              if(_formKey.currentState!.validate()) {
                                setState(() {
                                  isDeliveryBoyAdding = true;
                                });
                                await addNewDeliveryBoy();
                                setState(() {
                                  isDeliveryBoyAdding = false;
                                });
                                if(!success)
                                  return;
                                print('Popping out page');
                                Navigator.pop(
                                    context, [newDeliveryBoyDetails, success]);
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          isDeliveryBoyAdding ? Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(13),
                width: width * 0.7,
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
                      'Adding Delivery Boy',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              ),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
