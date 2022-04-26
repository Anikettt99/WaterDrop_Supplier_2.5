// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/add_items/add_item_type.dart';
import 'package:waterdrop_supplier/views/edit_items/edit_dispenser_details.dart';
import '../../helper/helper.dart';
import '../item_info.dart';
import '../notifications.dart';
import '../view_qr_code.dart';

class ListedItems extends StatefulWidget {
  const ListedItems({Key? key}) : super(key: key);

  @override
  _ListedItemsState createState() => _ListedItemsState();
}

class _ListedItemsState extends State<ListedItems> {
  List<Map<String, dynamic>> listedItems = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = false;
  List<bool> isSelected = [];
  bool deleteMode = false;
  List<String> selectedItems = [];
  String buttonText = 'REMOVE ITEMS';
  bool deletingItems = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    // TODO: implement initState
    HelperFunctions.getLocationIdSharedPreference().then((value) {
      dataBaseMethods.fetchListedItems().then((value) {
        setState(() {
          listedItems = value;
          for (var item in listedItems) {
            isSelected.add(false);
          }
          loading = false;
        });
      });
    });
    super.initState();
  }

  reInitializeSelecteditems() {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = false;
    }
  }

  Future<void> refreshData() async {
    var value = await dataBaseMethods.fetchListedItems();
    setState(() {
      listedItems = value;
      for (var item in listedItems) {
        isSelected.add(false);
      }
    });
    return;
  }

  Widget customAddOrRemoveButton2(BuildContext context, height, width,
      String text, IconData icon, Color containerColor, textSize) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: textSize * 1.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          'Listed Items',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ViewQrCode()));
          },
          child: Icon(Icons.qr_code),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              if (deleteMode) {
                if (selectedItems.isEmpty) {
                  dataBaseMethods.showToastNotification('No Items Selected');
                  return;
                }
                await showDialog(
                    context: context,
                    builder: (context) {
                      String endText =
                          selectedItems.length == 1 ? ' item?' : ' items?';
                      return AlertDialog(
                        title: Text(
                          'Are you sure you want to delete ' +
                              selectedItems.length.toString() +
                              endText,
                          style: const TextStyle(color: Colors.black),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                int i = 0;
                                setState(() {
                                  deletingItems = true;
                                });
                                for (var selectedItem in selectedItems) {
                                  if (i == 0) {
                                    Navigator.pop(context, true);
                                    bool isItemDeleted = await dataBaseMethods
                                        .deleteSelectedItem(selectedItem);
                                    print(isItemDeleted);
                                    if (!isItemDeleted) {
                                      dataBaseMethods.showToastNotification(
                                          'Server Error while deleting items');
                                      setState(() {
                                        deletingItems = false;
                                      });
                                      return;
                                    }
                                    i++;
                                  } else {
                                    dataBaseMethods
                                        .deleteSelectedItem(selectedItem);
                                  }
                                  listedItems.removeWhere((element) =>
                                      element['_id'] == selectedItem);
                                }
                                deletingItems = false;
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
                  print(value);
                  setState(() {
                    deleteMode = false;
                    if (buttonText == 'REMOVE ITEMS') {
                      buttonText = 'CANCEL';
                    } else {
                      buttonText = 'REMOVE ITEMS';
                    }
                    selectedItems = [];
                    reInitializeSelecteditems();
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
            reInitializeSelecteditems();
            setState(() {
              deleteMode = false;
              if (buttonText == 'REMOVE ITEMS') {
                buttonText = 'CANCEL';
              } else {
                buttonText = 'REMOVE ITEMS';
              }
            });
            return false;
          } else {
            return true;
          }
        },
        child: Stack(
          children: [
            loading
                ? Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : listedItems.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/no_products.png'),
                                    fit: BoxFit.fill)),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'No items added yet',
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Material(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddItemType(),
                                    ),
                                  ).then((value) async {
                                    setState(() {
                                      if (value == null) return;
                                      setState(() {
                                        listedItems.insert(0, value);
                                        isSelected.add(false);
                                      });
                                    });
                                    // initState();
                                  });
                                },
                                child: customAddOrRemoveButton2(
                                    context,
                                    50.0,
                                    MediaQuery.of(context).size.width * 0.50,
                                    '  ADD ITEMS',
                                    Icons.add_circle,
                                    primaryColor,
                                    20)),
                          )
                        ],
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await refreshData();
                          return;
                        },
                        color: primaryColor,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Material(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            onTap: () {
                                              if (deleteMode) {
                                                return;
                                              }
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AddItemType()))
                                                  .then((value) {
                                                if (value == null) return;
                                                setState(() {
                                                  listedItems.insert(0, value);
                                                  isSelected.add(false);
                                                });
                                              });
                                            },
                                            child: customAddOrRemoveButton(
                                                context,
                                                37.0,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                'ADD ITEMS',
                                                Icons.add_circle,
                                                primaryColor,
                                                14),
                                          ),
                                        ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.red.withOpacity(0.87),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            splashColor: Colors.red,
                                            onTap: () {
                                              print('Remove items called');
                                              reInitializeSelecteditems();
                                              setState(() {
                                                if (buttonText ==
                                                    'REMOVE ITEMS') {
                                                  buttonText = 'CANCEL';
                                                } else {
                                                  buttonText = 'REMOVE ITEMS';
                                                }
                                                HapticFeedback.vibrate();
                                                deleteMode = !deleteMode;
                                              });
                                            },
                                            child: customAddOrRemoveButton(
                                                context,
                                                37.0,
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.42,
                                                buttonText,
                                                Icons.cancel_rounded,
                                                Colors.red.withOpacity(0.87),
                                                14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                      //  color: Colors.black,
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'Listed Items',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ))
                                      : listedItems.isEmpty
                                          ? Container(
                                              height: 174,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: const Color.fromRGBO(
                                                      234, 171, 71, 0.7)),
                                              child: const Center(
                                                child: Text(
                                                  'No item has been listed yet',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            )
                                          : ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: listedItems.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                return Stack(
                                                  children: [
                                                    GestureDetector(
                                                      onLongPress: () {
                                                        HapticFeedback
                                                            .vibrate();
                                                        setState(() {
                                                          isSelected[index] =
                                                              true;
                                                          selectedItems.add(
                                                              listedItems[index]
                                                                  ['_id']);
                                                          if (buttonText ==
                                                              'REMOVE ITEMS') {
                                                            buttonText =
                                                                'CANCEL';
                                                          } else {
                                                            buttonText =
                                                                'REMOVE ITEMS';
                                                          }
                                                          deleteMode = true;
                                                        });
                                                      },
                                                      onTap: () {
                                                        if (deleteMode) {
                                                          setState(() {
                                                            isSelected[index] =
                                                                !isSelected[
                                                                    index];
                                                            if (isSelected[
                                                                index]) {
                                                              selectedItems.add(
                                                                  listedItems[
                                                                          index]
                                                                      ['_id']);
                                                            } else {
                                                              selectedItems.remove(
                                                                  listedItems[
                                                                          index]
                                                                      ['_id']);
                                                            }
                                                          });
                                                          return;
                                                        }
                                                        if (!listedItems[index]
                                                            ['isDispenser']) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ItemInfo(
                                                                            itemDetails:
                                                                                listedItems[index],
                                                                            productName: listedItems[index]['brandName'] +
                                                                                " " +
                                                                                listedItems[index]['qtyInLiters'].toString() +
                                                                                "L\n" +
                                                                                listedItems[index]['type'],
                                                                          )));
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          EditDispenserDetails(
                                                                            details:
                                                                                listedItems[index],
                                                                          )));
                                                        }
                                                      },
                                                      child: customItemCard(
                                                          context,
                                                          listedItems[index]),
                                                    ),
                                                    deleteMode
                                                        ? Checkbox(
                                                            shape:
                                                                CircleBorder(),
                                                            checkColor:
                                                                Colors.white,
                                                            activeColor:
                                                                primaryColor,
                                                            value: isSelected[
                                                                index],
                                                            onChanged: (val) {
                                                              setState(() {
                                                                isSelected[
                                                                        index] =
                                                                    val!;
                                                                if (val) {
                                                                  selectedItems.add(
                                                                      listedItems[
                                                                              index]
                                                                          [
                                                                          '_id']);
                                                                } else {
                                                                  selectedItems.remove(
                                                                      listedItems[
                                                                              index]
                                                                          [
                                                                          '_id']);
                                                                }
                                                              });
                                                            })
                                                        : Container(),
                                                  ],
                                                );
                                              })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            deletingItems
                ? Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 3,
                      child: Container(
                        padding: EdgeInsets.all(13),
                        width: MediaQuery.of(context).size.width * 0.6,
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
                              selectedItems.length == 1
                                  ? 'Deleting Item'
                                  : 'Deleting Items',
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
