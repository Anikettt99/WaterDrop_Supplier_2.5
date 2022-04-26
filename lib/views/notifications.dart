import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<Map<String , dynamic>> notifications = [];
  bool loading = true;
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  @override
  void initState() {
    // TODO: implement initState
    dataBaseMethods.fetchNotifications().then((value) {
      setState(() {
        notifications = value;
        loading = false;
      });
    });
    super.initState();
  }

  refreshData() async {
    final value = await dataBaseMethods.fetchNotifications();
    setState(() {
      notifications = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24
            ),
          ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,

        ),
      ),
      body: loading == true ? Center(
        child: CircularProgressIndicator(color: primaryColor,),
      ): notifications.length == 0 ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/no_noti.png'),
                    fit: BoxFit.fill)),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'You have Zero Notifications',
            style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 80,
          )
        ],
      ) : RefreshIndicator(
        onRefresh: () async {
          await refreshData();
        },
        color: primaryColor,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (BuildContext context, index) {
                  return notificationCard(context, notifications[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
