import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/delivery_partner/deliver_boy_form.dart';

import '../delivery_partner/delivery_boy_details.dart';
import '../notifications.dart';
import '../view_qr_code.dart';

class AddDeliveryBoy extends StatefulWidget {
  const AddDeliveryBoy({Key? key}) : super(key: key);

  @override
  _AddDeliveryBoyState createState() => _AddDeliveryBoyState();
}

class _AddDeliveryBoyState extends State<AddDeliveryBoy> {
  List<Map<String, dynamic>> deliveryBoys = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = false, isAvailable = true;
  bool selectAll = false;
  List<bool> isSelected = [];
  bool deleteMode = false;
  List<String> selectedPartners = [];
  String buttonText = 'Remove Delivery Partner';
  bool deletingPartner = false;

  Widget deliveryBoyCard(context, height, width, name, phoneNo, deliveryBoyId,
      isAvailable, index) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.2,
                    height: 80,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/personIcon.jpeg')),
                        shape: BoxShape.circle),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'View Details',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
              Icon(
                Icons.arrow_forward,
                color: primaryColor,
                size: 15,
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      loading = true;
    });
    dataBaseMethods.fetchDeliveryBoys().then((value) {
      setState(() {
        loading = false;
        deliveryBoys = value;
        for (var deliveryBoy in deliveryBoys) {
          isSelected.add(false);
        }
      });
    });
    super.initState();
  }

  refreshData() async {
    var value = await dataBaseMethods.fetchDeliveryBoys();
    setState(() {
      deliveryBoys = value;
      if (deliveryBoys.length != isSelected.length) {
        isSelected = [];
        for (var deliveryBoy in deliveryBoys) {
          isSelected.add(false);
        }
      }
    });
  }

  changeStatus(int index, bool val) {
    setState(() {
      deliveryBoys[index]['available'] = val;
    });
  }

  reInitializeSelectedPartners() {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ViewQrCode()));
          },
          child: const Icon(Icons.qr_code),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          'Delivery Partner',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (deleteMode) {
                if (selectedPartners.length == 0) {
                  dataBaseMethods.showToastNotification('No Items Selected');
                  return;
                }
                await showDialog(
                    context: context,
                    builder: (context) {
                      String endText = selectedPartners.length == 1
                          ? ' partner?'
                          : ' partners?';
                      return AlertDialog(
                        title: Text(
                          'Are you sure you want to delete ' +
                              selectedPartners.length.toString() +
                              endText,
                          style: const TextStyle(color: Colors.black),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () async {
                                Navigator.pop(context, true);
                                int i = 0;
                                setState(() {
                                  deletingPartner = true;
                                });
                                for (var deliveryPartner in selectedPartners) {
                                  if (i == 0) {
                                    bool isPartnerDeleted =
                                        await dataBaseMethods
                                            .deleteSelectedDeliveryPartner(
                                                deliveryPartner);
                                    print(isPartnerDeleted);
                                    if (!isPartnerDeleted) {
                                      dataBaseMethods.showToastNotification(
                                          'Server Error while deleting partner');
                                      setState(() {
                                        deletingPartner = false;
                                      });
                                      return;
                                    }
                                    i++;
                                  } else {
                                    dataBaseMethods
                                        .deleteSelectedDeliveryPartner(
                                            deliveryPartner);
                                  }
                                  deliveryBoys.removeWhere((element) =>
                                      element['_id'] == deliveryPartner);
                                }
                                deletingPartner = false;
                                dataBaseMethods.showToastNotification(
                                    'Successfully Deleted');
                                setState(() {});
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(color: primaryColor),
                              )),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: Text('No',
                                  style: TextStyle(color: primaryColor))),
                        ],
                      );
                    }).then((value) async {
                  setState(() {
                    deleteMode = false;
                    if (buttonText == 'Remove Delivery Partner')
                      buttonText = 'CANCEL';
                    else
                      buttonText = 'Remove Delivery Partner';
                    selectedPartners = [];
                    reInitializeSelectedPartners();
                  });
                });
                //deleteSelectedItems();
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Notifications()));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 12),
              child: Icon(
                deleteMode ? Icons.delete : Icons.notifications_none,
                color: Colors.white,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (deleteMode) {
            reInitializeSelectedPartners();
            setState(() {
              deleteMode = false;
              if (buttonText == 'Remove Delivery Partner')
                buttonText = 'CANCEL';
              else
                buttonText = 'Remove Delivery Partner';
            });
            return false;
          } else {
            return true;
          }
        },
        child: Stack(
          children: [
            loading
                ?  Center(child:  CircularProgressIndicator(color: primaryColor,))
                : deliveryBoys.length == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.34,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/no_delivery_boy.png'),
                                    fit: BoxFit.contain)),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(50),
                            color: primaryColor,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DeliveryBoyForm()))
                                      .then((value) {
                                        print(value);
                                        if(value == null)
                                          return;
                                        if(!value[1])
                                          return;
                                    setState(() {
                                      deliveryBoys.add(value[0]);
                                      isSelected = [];
                                      for (var deliveryBoy in deliveryBoys)
                                        isSelected.add(false);

                                      //switchState.add(true);
                                    });
                                    // initState();
                                  });
                                },
                                child: customAddOrRemoveButton(
                                    context,
                                    50.0,
                                    MediaQuery.of(context).size.width * 0.6,
                                    'Add Delivery Partner',
                                    Icons.add_circle,
                                    primaryColor,
                                    18)),
                          )
                        ],
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await refreshData();
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(50),
                                        color: primaryColor,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: () {
                                            if (deleteMode) return;
                                            Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DeliveryBoyForm()))
                                                .then((value) {
                                                  if(value == null)
                                                    return;
                                              if(!value[1])
                                                return;
                                              setState(() {
                                                deliveryBoys.add(value[0]);
                                                isSelected = [];
                                                for (var deliveryBoy in deliveryBoys)
                                                  isSelected.add(false);
                                                //switchState.add(true);
                                              });
                                            });
                                          },
                                          child: customAddOrRemoveButton(
                                              context,
                                              37.0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              'Add Delivery Partner',
                                              Icons.add_circle,
                                              primaryColor,
                                              12),
                                        ),
                                      ),
                                      Material(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red.withOpacity(0.87),
                                        child: InkWell(
                                          splashColor: Colors.red.shade900,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          onTap: () {
                                            setState(() {
                                              HapticFeedback.vibrate();
                                              deleteMode = !deleteMode;
                                              reInitializeSelectedPartners();
                                              if (buttonText ==
                                                  'Remove Delivery Partner')
                                                buttonText = 'CANCEL';
                                              else
                                                buttonText =
                                                    'Remove Delivery Partner';
                                            });
                                          },
                                          child: customAddOrRemoveButton(
                                              context,
                                              37.0,
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.45,
                                              buttonText,
                                              Icons.cancel_rounded,
                                              Colors.red.withOpacity(0.87),
                                              11.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20,
                                      child: const Text(
                                        'Select All',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 10,
                                      child: Checkbox(
                                        value: selectAll,
                                        onChanged: (val) async {
                                          setState(() {
                                            selectAll = val!;
                                          });
                                          if (val == false) return;
                                          for (int i = 0;
                                              i < deliveryBoys.length;
                                              i++) {
                                            deliveryBoys[i]['available'] = true;
                                            dataBaseMethods
                                                .changeDeliveryBoyStatus(
                                                    deliveryBoys[i]['_id'],
                                                    true);
                                          }
                                          dataBaseMethods.showToastNotification(
                                              'Updated Status of all Delivery Boys');
                                        },
                                        checkColor: Colors.white,
                                        activeColor: primaryColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: deliveryBoys.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return Stack(
                                        children: [
                                          Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              GestureDetector(
                                                onLongPress: () {
                                                  HapticFeedback.vibrate();
                                                  setState(() {
                                                    print(index);
                                                    isSelected[index] = true;
                                                    deleteMode = true;
                                                    selectedPartners.add(
                                                        deliveryBoys[index]
                                                            ['_id']);
                                                    if (buttonText ==
                                                        'Remove Delivery Partner')
                                                      buttonText = 'CANCEL';
                                                    else
                                                      buttonText =
                                                          'Remove Delivery Partner';
                                                    deleteMode = true;
                                                  });
                                                },
                                                onTap: () {
                                                  if (deleteMode) {
                                                    setState(() {
                                                      isSelected[index] =
                                                          !isSelected[index];
                                                      if (isSelected[index]) {
                                                        selectedPartners.add(
                                                            deliveryBoys[index]
                                                                ['_id']);
                                                      } else {
                                                        selectedPartners.remove(
                                                            deliveryBoys[index]
                                                                ['_id']);
                                                      }
                                                    });
                                                    return;
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DeliveryBoyDetails(
                                                                isAvailable:
                                                                    deliveryBoys[index]['available'],
                                                                deliveryBoyPhoneNumber:
                                                                    deliveryBoys[
                                                                            index]
                                                                        [
                                                                        'phone'],
                                                                deliveryBoyName:
                                                                    deliveryBoys[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                deliveryBoyId:
                                                                    deliveryBoys[
                                                                            index]
                                                                        ['_id'],
                                                                deliveryBoyAddress: deliveryBoys[index]['address'],
                                                              ))).then((value) {
                                                    changeStatus(
                                                        index, value[0]);
                                                  });
                                                },
                                                child: deliveryBoyCard(
                                                    context,
                                                    height,
                                                    width,
                                                    deliveryBoys[index]['name'],
                                                    deliveryBoys[index]['phone']
                                                        .toString(),
                                                    deliveryBoys[index]['_id'],
                                                    deliveryBoys[index]
                                                        ['available'],
                                                    index),
                                              ),
                                              Container(
                                                //  alignment: Alignment.bottomCenter,
                                                height: 50,
                                                width: 70,
                                                child: Switch(
                                                  activeColor: primaryColor,
                                                  value: deliveryBoys[index]
                                                      ['available'],
                                                  onChanged: (val) async {
                                                    setState(() {
                                                      deliveryBoys[index]
                                                      ['available'] =
                                                      !deliveryBoys[index]
                                                      ['available'];
                                                    });
                                                    bool success = await dataBaseMethods
                                                        .changeDeliveryBoyStatus(
                                                            deliveryBoys[index]
                                                                ['_id'],
                                                            deliveryBoys[index]
                                                                ['available']);
                                                    if(!success){
                                                      dataBaseMethods.showToastNotification('Failed to update status');
                                                      setState(() {
                                                        deliveryBoys[index]
                                                        ['available'] =
                                                        !deliveryBoys[index]
                                                        ['available'];
                                                      });
                                                      return;
                                                    }
                                                    dataBaseMethods
                                                        .showToastNotification(
                                                            'Updated Status');
                                                    print('&&&&&&&&7');
                                                    print(deliveryBoys[index]['available']);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          deleteMode
                                              ? Checkbox(
                                                  shape: CircleBorder(),
                                                  value: isSelected[index],
                                                  onChanged: (val) {
                                                    setState(() {
                                                      isSelected[index] = val!;
                                                      if (val) {
                                                        selectedPartners.add(
                                                            deliveryBoys[index]
                                                                ['_id']);
                                                      } else {
                                                        selectedPartners.remove(
                                                            deliveryBoys[index]
                                                                ['_id']);
                                                      }
                                                    });
                                                  })
                                              : Container(),
                                        ],
                                      );
                                    }),
                                const SizedBox(height: 100)
                              ],
                            ),
                          ),
                        ),
                      ),
            deletingPartner
                ? Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 3,
                      child: Container(
                        padding: EdgeInsets.all(13),
                        width: MediaQuery.of(context).size.width * 0.68,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularProgressIndicator(
                              color: primaryColor,
                            ),
                            Text(
                              selectedPartners.length == 1
                                  ? 'Deleting Partner'
                                  : 'Deleting Partners',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
