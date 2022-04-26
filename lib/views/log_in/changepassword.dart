import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

import 'log_in.dart';

class ChangePassword extends StatefulWidget {
  String phone;
  ChangePassword({Key? key, required this.phone}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool passwordhide = true;
  bool passwordhidecnf = true;
  TextEditingController password = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Form(
        key: _formKey,
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 90,
                        child: Stack(
                          children: [
                            Image.asset("assets/personIcon.jpeg"),
                            const Positioned(
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation(45 / 360),
                                child: Icon(Icons.vpn_key),
                              ),
                              bottom: 0,
                              right: 10,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "New Credentials",
                        style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        "Your identity has been verified!\nSet Your new Password!",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.2,
                          color: Color(0XFF979797),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: const [
                          Text(
                            "New Password",
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: password,
                        obscuringCharacter: '●',
                        obscureText: passwordhide,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0XFF979797))),
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: passwordhide
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordhide = false;
                                      });
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.eye_slash,
                                      color: Colors.black,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordhide = true;
                                      });
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.eye,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                        validator: (val){
                          if(val!.length == 0)
                            return 'Required';
                          else
                            return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: const [
                          Text(
                            "Confirm Password",
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        obscuringCharacter: '●',
                        obscureText: passwordhidecnf,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: const Color(0XFF979797))),
                          suffixIcon: Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: passwordhidecnf
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordhidecnf = false;
                                      });
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.eye_slash,
                                      color: Colors.black,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordhidecnf = true;
                                      });
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.eye,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        ),
                        validator: (val){
                          if(val!=password.text)
                            return "Password did not match";
                          else
                            return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          await dataBaseMethods.changePassword(widget.phone, password.text).then((value) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "PASSWORD UPDATED",
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: primaryColor,
                                        size: 48,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Your Password has been updated",
                                        style: const TextStyle(color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ),
                                actionsPadding: const EdgeInsets.all(0),
                                actions: [
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                              const LogIn(),
                                            ),
                                            ModalRoute.withName('/'));
                                      },
                                      child: const Text(
                                        "LOGIN",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0XFF22A45D),
                                        shape: const StadiumBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                          },
                        child: const Text(
                          "Update Password",
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
      ),
    );
  }
}
