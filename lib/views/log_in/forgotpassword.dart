import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

import 'changepassword.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String buttonText = "Get OTP";
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController phoneNumber = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  String otpEnterred = '';
  int start = 60;
  bool resendOtp = false;
  Timer? timer;

  void startTimer(){
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if(start == 0){
        setState(() {
          timer.cancel();
          start = 60;
          resendOtp = true;
          buttonText = "Get OTP";
        });
      }
      else{
        setState(() {
          resendOtp = false;
          start--;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  "OTP Verification",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "We will send you a one-time password to this mobile number",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1.2,
                        color: Color(0XFF979797),

                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Enter Phone Number",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.2,
                        color: Color(0XFF979797),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    TextFormField(
                      controller: phoneNumber,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                      ],


                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: buttonText == "Sending OTP" || buttonText == "OTP Sent" ? null : ()  async {
                        if(phoneNumber.text.length != 10){
                          dataBaseMethods.showToastNotification('Invalid Phone Number');
                          return;
                        }
                        setState(() {
                          buttonText = 'Sending OTP';
                        });
                        await dataBaseMethods.generateForgetPasswordOTP(phoneNumber.text);
                        startTimer();
                        setState(() {
                          buttonText = 'OTP Sent';
                        });

                      },
                      child: Text(
                        buttonText,
                        style: const TextStyle(fontSize: 17, letterSpacing: 1.2),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: primaryColor,
                        minimumSize: const Size(200, 50),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Text(
                      "Enter the OTP sent to your Phone Number",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 1.2,
                        color: Color(0XFF979797),
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OTPTextField(
                      length: 4,
                      controller: otpController,
                      width: MediaQuery.of(context).size.width * 0.8,
                      fieldWidth: MediaQuery.of(context).size.width * 0.15,
                      style: TextStyle(
                          fontSize: 20
                      ),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (otp) {
                        print("Completed: " + otp);
                        otpEnterred = otp;
                      },

                    ),
                    /*TextFormField(
                      controller: otpController,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                      ],
                    ),*/
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          resendOtp ? "Didn’t you receive the OTP? " : "You can resend the OTP in ",
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            color: Color(0XFF979797),
                          ),
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                          onTap: !resendOtp ? null : () async {
                            if(phoneNumber.text.length != 10){
                              dataBaseMethods.showToastNotification('Invalid Phone Number');
                              return;
                            }
                            setState(() {
                              buttonText = "OTP Sent";
                            });
                            dataBaseMethods.generateForgetPasswordOTP(phoneNumber.text);
                            startTimer();
                          },
                          child: Text(
                            resendOtp ? "Resend OTP" : start.toString() + "s",
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1,
                              color: primaryColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if(phoneNumber.text.length != 10){
                          dataBaseMethods.showToastNotification('Invalid Phone Number');
                          return;
                        }
                        await dataBaseMethods.verifyOTP(phoneNumber.text, otpEnterred).then((value) {
                          
                          print(value);
                          if(value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePassword(
                                            phone: phoneNumber.text)));
                          }
                          else {
                            dataBaseMethods.showToastNotification(
                                'Invalid Otp');
                          }
                        });
                        },
                      child: const Text(
                        "Verify OTP",
                        style: TextStyle(fontSize: 17, letterSpacing: 1.2),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: primaryColor,
                        minimumSize: const Size(200, 50),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
