import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';
import 'package:waterdrop_supplier/views/register/register_page.dart';
import 'package:waterdrop_supplier/views/log_in/forgotpassword.dart';

import '../../helper/constants.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool hidePassword = true;
  String? phoneNo, password;
  bool loading = false;
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController phoneNoTextEditingController = TextEditingController();
  SaveData saveData = SaveData();

  logMeIn() async {
   // await HelperFunctions.saveUserLoggedInSharedPreference(true);
    if(_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      final result = await dataBaseMethods.logIn(
          passwordTextEditingController.text,
          phoneNoTextEditingController.text);
      result == null ? setState(() {
        loading = false;
      }) : null;
      if (result != null) {
        await saveData.storeUserDataInLocalStorage(result);
        await HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
      }
      else {

      }
    }
  }

  getUserInfo() async {
    Constants.deliveryBoyDetailsDateTime = DateTime.now();
    Constants.customerInfoDateTime = DateTime.now();
    Constants.orderReceivedDateTime = DateTime.now();
    Constants.myLocationId = (await HelperFunctions.getLocationIdSharedPreference())!;
    Constants.myToken = (await HelperFunctions.getUserTokenSharedPreference())!;
    Constants.myPhoneNumber = (await HelperFunctions.getPhoneNumberSharedPreference())!;
    Constants.myMail = (await HelperFunctions.getUserMailIdSharedPreference())!;
    //Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    Constants.myStoreName = (await HelperFunctions.getStoreNameSharedPreference())!;
    Constants.myCode = (await HelperFunctions.getUserCodeSharedPreference())!;
    Constants.qrCodeLink = (await HelperFunctions.getUserQrCodeLinkSharedPreference())!;
    Constants.myAddress = (await HelperFunctions.getUserAddressSharedPreference())!;
    Constants.myShortAddress = (await HelperFunctions.getUserShortAddressSharedPreference())!;
    Constants.mySupplierId =  (await HelperFunctions.getSupplierIdSharedPreference())!;
    Constants.slot1StartTime = (await HelperFunctions.getUserSlot1StartTimeSharedPreference())!;
    Constants.slot1EndTime = (await HelperFunctions.getUserSlot1EndTimeSharedPreference())!;
    Constants.slot2StartTime = (await HelperFunctions.getUserSlot2StartTimeSharedPreference())!;
    Constants.slot2EndTime = (await HelperFunctions.getUserSlot2EndTimeSharedPreference())!;
    Constants.securityDepositAmount = (await HelperFunctions.getSecurityDepositAmountSharedPreference())!;
    Constants.myAadharNumber = (await HelperFunctions.getAadharCardNumberSharedPreference())!;
    Constants.myPanCardNumber = (await HelperFunctions.getPanCardNumberSharedPreference())!;
    Constants.myGSTNumber = (await HelperFunctions.getGSTNumberSharedPreference())!;
    Constants.headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Constants.myToken,
    };
    Constants.fastDeliveryCharges = (await HelperFunctions.getFastDeliveryChargeSharedPreference())!;
    print(Constants.headersMap);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        //physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: height * 0.4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/headerL.png'), fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.4 * 0.3,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter your Phone number and Password \nto Log In.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: phoneNoTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromRGBO(131, 131, 131, 1)
                                    ),
                                  )
                                ],
                              ),
                            ),
                            labelText: "PHONE NUMBER",
                            labelStyle: const TextStyle(fontSize: 12),
                            // hintText: "Mobile number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) {
                            return name == null ||  name.length == 0
                                ? 'Required'
                                : name.length < 10 || name.length > 10
                                ? 'Invalid phone number'
                                : null;
                          },
                          onSaved: (val) {
                            password = val;
                          },
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        TextFormField(
                          controller: passwordTextEditingController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            labelText: 'PASSWORD',
                            labelStyle: const TextStyle(fontSize: 12),
                            // hintText: 'Password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  hidePassword = !hidePassword;
                                  setState(() {});
                                },
                                icon: !hidePassword
                                    ? const Icon(CupertinoIcons.eye_slash_fill)
                                    : const Icon(CupertinoIcons.eye_fill)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onSaved: (val) {
                            password = val;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPassword(),
                            ),
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              // decoration: TextDecoration.underline
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(primaryColor),
                          ),
                          onPressed: loading ? null : () async {
                            await logMeIn();
                          },
                          child: Container(
                            width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  loading ? 'LOGGING IN' : 'LOG IN',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19
                                  ),
                                ),
                              ),
                          ),
                        ),

                        /*const Center(
                          child: Text(
                            'Or',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(1, 15, 7, 1)
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: width,
                          height: 42.7,
                          decoration: const BoxDecoration(

                            // color: secondaryColor,
                            color: Color.fromRGBO(66, 133, 244, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.all(3),
                                height: 26,
                                width: 24.91,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  'assets/google.png',
                                ),
                              ),
                              const InkWell(
                                child: Center(
                                  child: Text(
                                    "SIGN IN WITH GOOGLE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
                //alignment: FractionalOffset.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don’t have an account? ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text(
                        'Create a new account.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(0, 107, 255, 1),
                        ),
                      ),
                    )
                  ],
                )),
           // SizedBox(height: 200,)
          ],
        ),
      ),
    );
  }
}
