// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/services/saveData.dart';
import 'package:waterdrop_supplier/views/dashboard/add_customer.dart';

import '../customer/customer_order_summary.dart';

class CustomerInfo extends StatefulWidget {
  const CustomerInfo({Key? key}) : super(key: key);

  @override
  _CustomerInfoState createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  List<Map<String, dynamic>> customerInfo = [];
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    dataBaseMethods.fetchCustomerInfo().then((value) {
      setState(() {
        customerInfo = value;
        loading = false;
      });
    });
    super.initState();
  }

  refreshData() {
    dataBaseMethods.fetchCustomerInfo().then((value) {
      setState(() {
        customerInfo = value;
      });
    });
  }

  refreshDataWithoutLoading() async {
    var value = await dataBaseMethods.fetchCustomerInfo();

    setState(() {
      customerInfo = value;
    });
  }

  Widget customerInfoCard(context, Map<String, dynamic> customerInfo) {
    SaveData saveData = SaveData();
    String? name = customerInfo['name'];
    String? phoneNo = customerInfo['phone'];
    String? address = customerInfo['addresses'] == null ||
            customerInfo['addresses'].length == 0
        ? 'No Address Added Yet'
        : saveData.fetchCustomerAddressFromMap(customerInfo['addresses'][0]);
        // int canValue=;
    String? noOfCans = customerInfo['emptyCans'] == null ? '0' customerInfo['emptyCans'].toString();
    // int walletValue=(customerInfo['wallet']) ;
    String? walletBalance = customerInfo['wallet'].toString();
    bool isWalletNegative = double.parse(walletBalance) < 0 ? true : false;
    if(isWalletNegative) {
      walletBalance = walletBalance.substring(1, walletBalance.length);
    }
    String customerId = customerInfo['_id'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerOrderSummary(
                      name: name,
                      phoneNo: phoneNo,
                      address: address,
                      noOfCans: noOfCans,
                      walletBalance: walletBalance,
                      isWalletNegative: isWalletNegative,
                      id: customerId,
                    ))).then((value) {
          if (value) {
            refreshData();
          }
        });
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Text(
                              name!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "+91 " + phoneNo!,
                            style: const TextStyle(
                                color: Color.fromRGBO(134, 134, 134, 1),
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black12),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  noOfCans,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700),
                                ),
                                const Text(
                                  'NO. OF CANS',
                                  style: TextStyle(
                                      color: Color.fromRGBO(100, 100, 100, 1),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 28,
                              width: 1,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text.rich(TextSpan(text: '', children: [
                                  TextSpan(
                                    text: '₹ ',
                                    style: TextStyle(
                                      color: isWalletNegative ? Colors.red.withOpacity(0.87) : primaryColor,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: walletBalance,
                                    style: TextStyle(
                                      color: isWalletNegative ? Colors.red.withOpacity(0.87) : primaryColor,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ])),
                                const SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  isWalletNegative ? 'BALANCE DUE' : 'WALLET BALANCE',
                                  style: const TextStyle(
                                      color: Color.fromRGBO(100, 100, 100, 1),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          address!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color.fromRGBO(134, 134, 134, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'View More',
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: CircularProgressIndicator(color: primaryColor,),),)
        : customerInfo.isEmpty
            ? Column(
              children: [ Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Customers: " + customerInfo.length.toString(),
                            style: TextStyle(color: secondaryColor, fontSize: 18),
                          ),
                         ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCustomer()));
                },
                icon: Icon(Icons.add_circle),
                label: Text("Add Customer"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: primaryColor,
                  maximumSize: Size(
                    MediaQuery.of(context).size.width * .5,
                    40,
                  ),
                ),
              ),
                        ],
                      ),
                    ),
                noDataDashboard(context),
              ],
            )
            : RefreshIndicator(
                onRefresh: () async {
                  await refreshDataWithoutLoading();
                },
                color: primaryColor,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Customers: " + customerInfo.length.toString(),
                            style: TextStyle(color: secondaryColor, fontSize: 18),
                          ),
                         ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCustomer()));
                },
                icon: Icon(Icons.add_circle),
                label: Text("Add Customer"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  primary: primaryColor,
                  maximumSize: Size(
                    MediaQuery.of(context).size.width * .5,
                    40,
                  ),
                ),
              ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: customerInfo.length,
                        itemBuilder: (BuildContext context, index) {
                          return customerInfoCard(context, customerInfo[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 0);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              );
  }
}
