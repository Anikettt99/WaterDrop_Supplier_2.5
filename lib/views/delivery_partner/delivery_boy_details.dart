import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

import 'edit_delivery_boy_details.dart';

class DeliveryBoyDetails extends StatefulWidget {
  bool isAvailable;
  String? deliveryBoyPhoneNumber;
  String? deliveryBoyName;
  String? deliveryBoyId;
  String? deliveryBoyAddress;

  DeliveryBoyDetails(
      {Key? key,
      required this.isAvailable,
      this.deliveryBoyPhoneNumber,
      this.deliveryBoyName,
      this.deliveryBoyId,
      this.deliveryBoyAddress})
      : super(key: key);

  @override
  _DeliveryBoyDetailsState createState() => _DeliveryBoyDetailsState();
}

class _DeliveryBoyDetailsState extends State<DeliveryBoyDetails> {
  List<Map<String, dynamic>> ordersDelivered = [];
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = true;
  String _selectedDate = '';
  HelperFunctions helperFunctions = HelperFunctions();

  @override
  void initState() {
    print('@@@@@@');
    print(widget.isAvailable);
    var currDt = Constants.deliveryBoyDetailsDateTime;
    // print(currDt);
    var formatedDate = DateFormat('yyyy-MM-dd').format(currDt);
    _selectedDate = formatedDate;
    // TODO: implement initState
    dataBaseMethods
        .fetchOrdersDeliveredByParticularDeliveryBoy(
            widget.deliveryBoyId, _selectedDate)
        .then((value) {
      setState(() {
        ordersDelivered = value;
        loading = false;
      });
    });
    super.initState();
  }

  updateData(selectedDate) {
    dataBaseMethods
        .fetchOrdersDeliveredByParticularDeliveryBoy(
            widget.deliveryBoyId, _selectedDate)
        .then((value) {
      setState(() {
        ordersDelivered = value;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, [widget.isAvailable]);
            },
            icon: const Icon(CupertinoIcons.back),
            color: Colors.white),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditDeliveryBoyDetails(
                            address: widget.deliveryBoyAddress!,
                            name: widget.deliveryBoyName!,
                            phoneNo: widget.deliveryBoyPhoneNumber!,
                            id: widget.deliveryBoyId!,
                          ))).then((value) {
                            if(value == null){
                              return;
                            }

                            setState(() {
                              widget.deliveryBoyName = value[1];
                              widget.deliveryBoyAddress = value[2];
                              widget.deliveryBoyPhoneNumber = value[3];
                            });
              });
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 8, right: 12),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
        title: const Text(
          "Delivery Partner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, [widget.isAvailable]);
          return false;
        },
        child: loading
            ? Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator(color: primaryColor,)))
            : ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.25,
                                width: MediaQuery.of(context).size.width * 0.25,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          'assets/personIcon.jpeg',
                                        ),
                                        fit: BoxFit.fill),
                                    shape: BoxShape.circle)),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.56,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7 *
                                                0.55,
                                        child: Text(
                                          widget.deliveryBoyName!,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        //  alignment: Alignment.bottomCenter,
                                        height: 40,
                                        width: 25,
                                        child: Switch(
                                          activeColor: primaryColor,
                                          value: widget.isAvailable,
                                          onChanged: (val) async {
                                            setState(() {
                                              widget.isAvailable =
                                                  !widget.isAvailable;
                                            });
                                            bool success = await dataBaseMethods
                                                .changeDeliveryBoyStatus(
                                                    widget.deliveryBoyId,
                                                    widget.isAvailable);
                                            if (!success) {
                                              dataBaseMethods
                                                  .showToastNotification(
                                                      'Failed to update status');
                                              setState(() {
                                                widget.isAvailable =
                                                    !widget.isAvailable;
                                              });
                                              return;
                                            }
                                            dataBaseMethods
                                                .showToastNotification(
                                                    'Updated Status');
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '+91 ' + widget.deliveryBoyPhoneNumber!,
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  child: Text(
                                    widget.deliveryBoyAddress!,
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(_selectedDate),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                  firstDate: DateTime(2021),
                                ).then((value) {
                                  if (value == null) return;
                                  Constants.deliveryBoyDetailsDateTime = value;
                                  setState(() {
                                    if (_selectedDate ==
                                        value.toString().substring(0, 10))
                                      return;
                                    _selectedDate =
                                        value.toString().substring(0, 10);
                                    // _selectedDate = helperFunctions.formatDate(_selectedDate);
                                    loading = true;

                                    updateData(_selectedDate);
                                  });
                                });
                              },
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  width: 140,
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        helperFunctions
                                            .formatDate(_selectedDate),
                                        style: TextStyle(fontSize: 17),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'ORDERS DELIVERED: ' +
                                  ordersDelivered.length.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ordersDelivered.length == 0
                            ? Center(
                                child: noDataDashboard(context),
                              )
                            : ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: ordersDelivered.length,
                                itemBuilder: (BuildContext context, index) {
                                  return customOrdersDeliveredCard(
                                      context,
                                      ordersDelivered[index],
                                      widget.deliveryBoyName);
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 0);
                                },
                              ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
