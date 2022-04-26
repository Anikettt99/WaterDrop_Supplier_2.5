import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/homepage/home_page.dart';


class EditDispenserDetails extends StatefulWidget {
  Map<String, dynamic> details;
  EditDispenserDetails({Key? key, required this.details}) : super(key: key);

  @override
  _EditDispenserDetailsState createState() => _EditDispenserDetailsState();
}

class _EditDispenserDetailsState extends State<EditDispenserDetails> {
  Map<String, dynamic> details = {};
  int isJar = 1;
  final _formKey = GlobalKey<FormState>();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = false;

  @override
  void initState() {
    details = widget.details;
    isJar = details['isDispenserAutomatic'] ? 0 : 1;
    super.initState();
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
            color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Edit Item Details",
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
                    'EDIT DISPENSER DETAILS',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: details['brandName'],
                   // controller: brandName,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      labelText: "Brand Name",
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
                    onSaved: (val){
                      details['brandName'] = val;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: details['unitPrice'].toString(),
                   // controller: price,
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
                    validator: (name) {
                      if (name!.length == 0) {
                        return 'Required';
                      }
                      if(int.parse(name) == 0){
                        return 'Price cannot be zero';
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                    ],
                    onSaved: (val){
                      details['unitPrice'] = val;
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
                      const SizedBox(
                        width: 40,
                      ),
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
                  const SizedBox(height: 20),
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
              padding: EdgeInsets.all(13),
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
                    'Editing Item',
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
                      fontSize: 18,
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
                    _formKey.currentState!.save();
                    print(details);
                    details['isDispenserAutomatic'] = isJar == 1 ? false : true;
                    setState(() {
                      loading = true;
                    });
                    await dataBaseMethods.editItemDetails(details['_id'], details);
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  HomePage(index: 0,)));
                  }
                },
                child: const Center(
                  child: Text(
                    "SAVE",
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
        ),
      ),
    );
  }
}
