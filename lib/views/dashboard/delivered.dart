import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

int updateDataIndex = 0;
String updatedDeliveryBoyId = '';
class Delivered extends StatefulWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  _DeliveredState createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  List<Map<String, dynamic>> deliveredOrders = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    dataBaseMethods.fetchDeliveredOrders().then((value) {
      if(value == null)
        return;
      setState(() {
        deliveredOrders = value;
        loading = false;
      });
    });

    super.initState();
  }

  refreshData() async{
    var value = await dataBaseMethods.fetchDeliveredOrders();
    setState(() {
      deliveredOrders = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(child: CircularProgressIndicator(color: primaryColor,)))
        : deliveredOrders.length == 0
            ? Center(child: noDataDashboard(context))
            : RefreshIndicator(
              onRefresh: () async {
                await refreshData();
              },
              child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 15),
                      child: Center(
                        child: Text(
                          "Orders Delivered Today: " + deliveredOrders.length.toString(),
                          style: TextStyle(color: secondaryColor, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: deliveredOrders.length,
                        itemBuilder: (BuildContext context, index) {
                          return customOrdersReceivedCard(
                              context, deliveredOrders[index]);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 0);
                        },
                      ),
                    ),
                  ],
                ),
            );
  }
}


