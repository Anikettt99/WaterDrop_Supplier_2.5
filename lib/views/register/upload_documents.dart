import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/register/register_page.dart';

class UploadDocuments extends StatefulWidget {
  final Function? onBackCallBack, onChangeCallBack;

  const UploadDocuments({Key? key, this.onBackCallBack, this.onChangeCallBack})
      : super(key: key);

  @override
  _UploadDocumentsState createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  final _formKey = GlobalKey<FormState>();
  int val = 1;
  int gstVal = 1;
  TextEditingController panNumberTextEditingController =
      TextEditingController();
  TextEditingController legalEntityNameTextEditingController =
      TextEditingController();
  TextEditingController legalEntityAddressTextEditingController =
      TextEditingController();
  TextEditingController gstinNumberTextEditingController =
      TextEditingController();
  TextEditingController bankAccNoTextEditingController =
      TextEditingController();
  TextEditingController accountTypeTextEditingController =
      TextEditingController();
  TextEditingController bankIfscCodeTextEditingController =
      TextEditingController();
  TextEditingController reEnterBankAccountTextEditingController = TextEditingController();
  var accountType = ['Savings', 'Current'];
  String accountTypeDropDownValue = 'Savings';
  String checker = '';

  @override
  void initState() {
    accountTypeDropDownValue = supplier.accType == null ||  supplier.accType! == '' ? 'Savings' : supplier.accType!;
    supplier.accType = accountTypeDropDownValue;
    gstVal = supplier.isGstRegistered == null || supplier.isGstRegistered! ? 1 : 0;
    // TODO: implement initState
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 30, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "UPLOAD LEGAL DOCUMENTS",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(232, 194, 115, 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'A mistake in this section can lead to delays in onboarding process. Please follow all instructions very carefully.',
                          //textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 5,
                height: 40,
                color: Color(0xFFE6E6E6),
              ),
              buildDropContainer(
                context,
                width,
                height,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      TextFormField(
                          initialValue: supplier.panNo,
                       // controller: panNumberTextEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "PAN number of the owner*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]+')),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onSaved: (val) {
                          supplier.panNo = val;
                        },
                        validator: (val){
                            if(val!.isEmpty)
                              return 'Required';
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: supplier.panName,
                       // controller: legalEntityNameTextEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "Owner's Name*",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z .]+')),
                        ],
                        validator: (val) {
                          if (val!.length == 0)
                            return 'Required';
                          else
                            return null;
                        },
                        onSaved: (val) {
                          supplier.panName = val;
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                'PAN details',
                true,
              ),
              const Divider(
                thickness: 5,
                height: 40,
                color: Color(0xFFE6E6E6),
              ),
              buildDropContainer(
                context,
                width,
                height,
               Container(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        "Is your store GST registered?",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Radio(
                                value: 1,
                                groupValue: gstVal,
                                onChanged: (num) {
                                  setState(() {
                                    gstVal = 1;
                                    supplier.isGstRegistered = true;
                                  });
                                }),
                            Text(
                              "Yes",
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Row(
                          children: [
                            Radio(
                                value: 0,
                                groupValue: gstVal,
                                onChanged: (num) {
                                  setState(() {
                                    gstVal = 0;
                                    supplier.isGstRegistered = false;
                                  });
                                }),
                            Text(
                              "No",
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      gstVal == 0 ? Container() : TextFormField(
                        controller: gstinNumberTextEditingController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          labelText: "GSTIN number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSaved: (val) {
                          supplier.gstNo = val;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15)
                        ],
                        validator: (val) {
                            if(val!.length == 0)
                              return 'Required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                "GST information",
                true,
              ),
              const Divider(
                thickness: 5,
                height: 40,
                color: Color(0xFFE6E6E6),
              ),
              SizedBox(
                height: 4,
              ),
              buildDropContainer(context,
                  width,
                  height,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: supplier.bankAccNo,
                          keyboardType: TextInputType.number,
                         // controller: bankAccNoTextEditingController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Bank account number*",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (val) {
                            if (val!.length == 0)
                              return 'Required';
                            else
                              return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                          ],
                          onSaved: (name){
                              checker = name!;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: supplier.bankAccNo,
                        //  controller: reEnterBankAccountTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Re-enter account number*",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (val) {
                            if (bankAccNoTextEditingController.text != reEnterBankAccountTextEditingController.text)
                              return 'Account number did not match';
                            else
                              return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                          ],
                          onSaved: (val) {
                            supplier.bankAccNo = val;
                          },
                        ),
                        const SizedBox(height: 12),
                        /*TextFormField(
                          controller: accountTypeTextEditingController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Select account type",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (val) {
                            if (val!.length == 0)
                              return 'Required';
                            else
                              return null;
                          },
                          onSaved: (val) {
                            supplier.accType = val;
                          },
                        ),*/
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButtonFormField(
                            value: accountTypeDropDownValue,
                            isExpanded: true,
                            items: accountType.map((String items) {
                              return DropdownMenuItem(value: items, child: Text(items));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                supplier.accType = newValue.toString();
                                accountTypeDropDownValue = newValue.toString();
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              hintText: "Select Account Type",
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: supplier.ifscCode,
                       //   controller: bankIfscCodeTextEditingController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            labelText: "Bank IFSC code*",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]+')),
                            LengthLimitingTextInputFormatter(11)
                          ],
                          validator: (val) {
                            if (val!.length == 0)
                              return 'Required';
                            else
                              return null;
                          },
                          onSaved: (val) {
                            supplier.ifscCode = val;
                          },
                        ),
                      ],
                    ),
                  ),
                  'Bank Details',
                  true),
              const Divider(
                thickness: 5,
                height: 40,
                color: Color(0xFFE6E6E6),
              ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 15, left: 15, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  UPI Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),),
                          const SizedBox(height: 5,),
                          TextFormField(
                            initialValue: supplier.upiId,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              labelText: "UPI Id",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onSaved: (name) {
                              supplier.upiId = name;
                            },
                          ),
                        ],
                      ),

                    ),
              const Divider(
                thickness: 5,
                height: 40,
                color: Color(0xFFE6E6E6),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
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
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        print('Hello');
                        widget.onBackCallBack!();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(checker);
                          print(supplier.bankAccNo);
                          if(checker != supplier.bankAccNo){
                            DataBaseMethods().showToastNotification('Bank account number did not match');
                            return;
                          }
                          print(supplier.accType);
                          widget.onChangeCallBack!();
                        }
                        //widget.onChangeCallBack!();
                      },
                      child: nextButton()
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
