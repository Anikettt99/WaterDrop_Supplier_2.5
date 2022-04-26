import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import '../../services/database.dart';

class CancelledOrders extends StatefulWidget {
  const CancelledOrders({Key? key}) : super(key: key);

  @override
  State<CancelledOrders> createState() => _CancelledOrdersState();
}

class _CancelledOrdersState extends State<CancelledOrders> {
  List<Map<String, dynamic>> cancelledOrders = [];
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    dataBaseMethods.fetchCancelledOrders().then((value) {
      if(value == null)
        return;
      setState(() {
        cancelledOrders = value;
        loading = false;
      });
    });

    super.initState();
  }

  refreshData() async{
    var value = await dataBaseMethods.fetchCancelledOrders();
    setState(() {
      cancelledOrders = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(child: CircularProgressIndicator(color: primaryColor,)))
        : cancelledOrders.length == 0
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
                "Orders Cancelled Today: " + cancelledOrders.length.toString(),
                style: TextStyle(color: secondaryColor, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cancelledOrders.length,
              itemBuilder: (BuildContext context, index) {
                return customOrdersCancelledCard(
                    context, cancelledOrders[index]);
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
