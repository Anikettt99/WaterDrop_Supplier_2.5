import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/model/supplier.dart';
import 'package:waterdrop_supplier/views/register/create_password.dart';
import 'package:waterdrop_supplier/views/register/store_informaton.dart';
import 'package:waterdrop_supplier/views/register/upload_documents.dart';

Supplier supplier = new Supplier();
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selected = 1;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          Container(
            height: height * 0.35,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/headerS.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.13,
                ),
                const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Register Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(67, 0, 60, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                      //  selected = 1;
                        setState(() {});
                      },
                      child: buildCircleCont(
                        context,
                        width,
                        height,
                        1,
                        selected,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                    //    selected = 2;
                        setState(() {});
                      },
                      child: buildCircleCont(
                        context,
                        width,
                        height,
                        2,
                        selected,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                    //    selected = 3;
                        setState(() {});
                      },
                      child: buildCircleCont(
                        context,
                        width,
                        height,
                        3,
                        selected,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Text(
                        "Store\nInformation",
                        style: TextStyle(height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                       // selected = 1;
                        setState(() {});
                      },
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        "Upload\nDocuments",
                        style: TextStyle(height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                       // selected = 2;
                        setState(() {});
                      },
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        "Create\nPassword",
                        style: TextStyle(height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                      //  selected = 3;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              selected == 1
                  ? StoreInformation(
                onBackCallBack: (){
                  selected-=1;
                  setState(() {

                  });
                },
                onChangeCallBack: (){
                  selected+=1;
                  setState(() {

                  });
                }
              )
                  : selected == 2
                  ? UploadDocuments(
                onBackCallBack: (){
                  selected-=1;
                  setState(() {

                  });
                },
                onChangeCallBack: (){
                  selected+=1;
                  setState(() {

                  });
                },
              )
                  : CreatePassword(
                    onBackCallBack: (){
                      selected-=1;
                      setState(() {

                      });
                    }
              )
            ],
          )
        ],
      ),
    );
  }
}
