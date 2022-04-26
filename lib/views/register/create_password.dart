import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';
import 'package:waterdrop_supplier/views/log_in/log_in.dart';
import 'package:waterdrop_supplier/views/pdf_viewer.dart';
import 'package:waterdrop_supplier/views/register/register_page.dart';

import '../homepage/dashboard.dart';

class CreatePassword extends StatefulWidget {
  final Function? onBackCallBack;

  const CreatePassword({Key? key, this.onBackCallBack}) : super(key: key);

  @override
  _CreatePasswordState createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  SaveData saveData = SaveData();
  bool agreeToTermsAndCondition = false;
  bool registering = false;
  bool isPhoneVerified = false;

  signMeUp() async {
    if (_formKey.currentState!.validate()) {
      if (!agreeToTermsAndCondition) {
        dataBaseMethods
            .showToastNotification('Please agree to our terms and conditions');
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        registering = true;
      });
      final result = await dataBaseMethods.registerStore();
      print(result);
      if (result['success'] == null) {
        await HelperFunctions.saveUserLoggedInSharedPreference(true);
        await saveData.storeUserDataInLocalStorage(result);
        setState(() {
          registering = false;
        });
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage(index: 0,)));
      } else {
        setState(() {
          registering = false;
        });
        print('Result is null');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Text(
                        "CREATE PASSWORD",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        hintText: supplier.storePhNo ?? '1234567891',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        disabledBorder: OutlineInputBorder(),
                      ),
                      enableInteractiveSelection: false,
                      enabled: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: password,
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
                      onSaved: (val) {
                        supplier.password = val;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: confirmPassword,
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
                      validator: (val) {
                        return val == password.text
                            ? null
                            : 'Password didn\'t match';
                      },
                      onSaved: (val) {
                        supplier.confirmPassword = val;
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 20,
                height: 40,
                color: Color(0xFFE6E6E6),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: GestureDetector(
                            child: Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.arrowtriangle_left_fill,
                                    size: 12,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    " GO BACK",
                                    style: TextStyle(
                                        color: primaryColor, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              widget.onBackCallBack!();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      onPressed: isPhoneVerified ? null : () async {
                        dataBaseMethods.generateVerifySupplierOTP(supplier.storePhNo);
                        await showDialog(context: context, builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: MediaQuery.of(context)
                                  .size
                                  .height *
                                  0.2,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    'Enter OTP sent to ' + supplier.storePhNo.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                  const SizedBox(height: 20,),
                                  OTPTextField(
                                    length: 4,
                                    width: MediaQuery.of(context).size.width *
                                        0.8,
                                    fieldWidth:
                                    MediaQuery.of(context).size.width *
                                        0.15,
                                    style: TextStyle(fontSize: 20),
                                    textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.underline,
                                    onCompleted: (otp) async {
                                      bool success = await dataBaseMethods
                                          .verifyOTP(
                                          supplier.storePhNo, otp);
                                      if(!success){
                                        return;
                                      }
                                      setState(() {
                                        isPhoneVerified = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      child: Text(
                        'Verify Phone Number',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
    ),
                    ),
                    const SizedBox(height: 5,),
                    FlatButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 45,
                      onPressed : !isPhoneVerified ? null : () async {
                        if(!isPhoneVerified){
                          dataBaseMethods.showToastNotification('Phone Number Not Verified');
                          return;
                        }
                        await signMeUp();
                      },
                      child: Text(
                        registering ? 'REGISTERING' : 'REGISTER MY STORE',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                      color: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: agreeToTermsAndCondition,
                          onChanged: (val) {
                            setState(() {
                              agreeToTermsAndCondition = val!;
                            });
                          },
                          fillColor: MaterialStateProperty.all(primaryColor),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.comfortable,
                        ),
                        Text(
                          "Agree to our ",
                          style: TextStyle(
                            height: 2,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PdfViewer()));
                          },
                          child: Text(
                            "Terms Conditions & Privacy Policy.",
                            style: TextStyle(
                                height: 2,
                                color: primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogIn()));
                      },
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 107, 255, 1),
                            fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
