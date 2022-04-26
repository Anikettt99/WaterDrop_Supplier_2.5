/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/views/homepage/listed_items.dart';

class AddItemDetails extends StatefulWidget {
  const AddItemDetails({Key? key}) : super(key: key);

  @override
  _AddItemDetailsState createState() => _AddItemDetailsState();
}

class _AddItemDetailsState extends State<AddItemDetails> {
  int availableToPack = 1;
  int normalWater = 1;
  String brandNameDropDownValue = 'Bisleri';
  var brandName = ['Bisleri', 'Kinley', 'Aquafina', 'Bailey', 'Himalayan'];
  String itemQuantityDropDownValue = '250';
  var itemQuantity = ['1', '1.5', '2', '250', '300', '350', '500', '750'];

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADD WATER BOTTLE DETAILS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Is it available in pack or not?',
                style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1), fontSize: 16),
              ),
              Row(
                children: [
                  Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: availableToPack,
                    value: 1,
                    onChanged: (value) {
                      setState(() {
                        availableToPack = 1;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  const Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: availableToPack,
                    value: 0,
                    onChanged: (value) {
                      setState(() {
                        availableToPack = 0;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  const Text(
                    'No',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(
                height: availableToPack == 1 ?  8 : 0,
              ),
              availableToPack == 1 ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.6,
                    child: Text(
                      'How many bottles are Present in a pack?',
                      style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1), fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width * 0.2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        */
/*suffixIcon: Icon(
                            Icons.check,
                            color: secondaryColor,
                          ),*//*

                      ),
                    ),
                  ),
                ],
              ) : Container(),
              const SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width * 0.6,
                    child: Text(
                      availableToPack == 1 ? 'How many packs are available in your stock?' : 'How many bottles are available in your stock',
                      style: TextStyle(color: Color.fromRGBO(131, 131, 131, 1), fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width * 0.2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        labelText: "",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        */
/*suffixIcon: Icon(
                            Icons.check,
                            color: secondaryColor,
                          ),*//*

                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 14,
              ),
              ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  items: brandName.map((String items) {
                    return DropdownMenuItem(
                        value: items, child: Text(items));
                  }).toList(),
                  onChanged: (newValue){
                    setState(() {
                      brandNameDropDownValue = newValue.toString();
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    labelText: "Select Brand Name",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ButtonTheme(
               alignedDropdown: true,
                child: DropdownButtonFormField(
                  items: itemQuantity.map((String items) {
                    return DropdownMenuItem(
                        value: items, child: Text(items));
                  }).toList(),
                  onChanged: (newValue){
                    setState(() {
                      itemQuantityDropDownValue = newValue.toString();
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    labelText: "Item Quantity(L)",
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    groupValue: normalWater,
                    value: 1,
                    onChanged: (value) {
                      setState(() {
                        normalWater = 1;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  const Text(
                    'Normal water',
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
                    groupValue: normalWater,
                    value: 0,
                    onChanged: (value) {
                      setState(() {
                        normalWater = 0;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  const Text(
                    'Chilled water',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
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
                          color: Colors.grey.shade600,
                          fontSize: height / 40),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Text(
                          "ADD ITEM",
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
    );
  }
}
*/
