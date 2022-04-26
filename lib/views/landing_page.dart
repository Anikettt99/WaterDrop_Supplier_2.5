// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/dashboard/add_customer.dart';
import 'package:waterdrop_supplier/views/log_in/log_in.dart';
import 'package:waterdrop_supplier/views/register/register_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/Group 4.png'), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.62,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LogIn()));
                  },
                  child: customButton(
                      context,
                      42.7,
                      width,
                      'LOG IN',
                      Colors.white,
                      Color.fromRGBO(0, 107, 255, 1),
                      Colors.white)),
              SizedBox(
                height: height * 0.03,
              ),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                },
                child: customButton(context, 42.7, width, 'REGISTER',
                    Color.fromRGBO(0, 107, 255, 1), Colors.white, Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
