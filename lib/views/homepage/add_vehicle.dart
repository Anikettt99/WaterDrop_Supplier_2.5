import 'package:flutter/material.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/views/delivery_partner/deliver_boy_form.dart';

import '../notifications.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  Map<String, int> vehicles = {'2 Wheeler': 0, '3 Wheeler': 0, '4 Wheeler': 2};
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool loading = false, isAvailable = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      loading = true;
    });
    dataBaseMethods.fetchVehicles().then((value) {
      setState(() {
        loading = false;
        vehicles = value;
      });
    });
    super.initState();
  }

  changeVehicleNumber(int index, int changeVal) {
    if (index == 0) {
      int? val = vehicles['2 Wheeler'];
      if (val == null || (val == 0 && changeVal == -1)) {
        return;
      } else {
        val += changeVal;
      }
      setState(() {
        vehicles['2 Wheeler'] = val!;
      });
    } else if (index == 1) {
      int? val = vehicles['3 Wheeler'];
      if (val == null || (val == 0 && changeVal == -1)) {
        return;
      } else {
        val += changeVal;
      }
      setState(() {
        vehicles['3 Wheeler'] = val!;
      });
    } else {
      int? val = vehicles['4 Wheeler'];
      if (val == null || (val == 0 && changeVal == -1)) {
        return;
      } else {
        val += changeVal;
      }
      setState(() {
        vehicles['4 Wheeler'] = val!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: primaryColor,
        title: const Text(
          'Statistics',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 25),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Notifications()));
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 8, right: 12),
              child: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: loading
          ?  Center(child: CircularProgressIndicator(color: primaryColor,))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Ink(
                            child: InkWell(
                              onTap: () {

                              },
                              child: customAddOrRemoveButton(
                                  context,
                                  37.0,
                                  MediaQuery.of(context).size.width * 0.45,
                                  'Add Vehicle',
                                  Icons.add_circle,
                                  primaryColor,
                                  16),
                            ),
                          ),
                          customAddOrRemoveButton(
                              context,
                              37.0,
                              MediaQuery.of(context).size.width * 0.45,
                              'Remove Vehicle',
                              Icons.cancel_rounded,
                              Colors.red.withOpacity(0.87),
                              15),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: height * 0.7,
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (BuildContext context, index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                index == 0
                                    ? vehicleCard(height, width,
                                        'assets/vehicle.png', '2 Wheeler')
                                    : index == 1
                                        ? vehicleCard(height, width,
                                            'assets/vehicle.png', '3 Wheeler')
                                        : vehicleCard(height, width,
                                            'assets/vehicle.png', '4 Wheeler'),
                                Container(
                                    //  alignment: Alignment.bottomCenter,
                                    height: 50,
                                    width: 70,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              changeVehicleNumber(index, -1);
                                            },
                                            child: const Text(
                                              '-',
                                              style: TextStyle(
                                                fontSize: 40,
                                              ),
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 25,
                                          child: Center(
                                            child: Text(
                                              index == 0
                                                  ? vehicles['2 Wheeler']
                                                      .toString()
                                                  : index == 1
                                                      ? vehicles['3 Wheeler']
                                                          .toString()
                                                      : vehicles['4 Wheeler']
                                                          .toString(),
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            changeVehicleNumber(index, 1);
                                          },
                                          child: const Text(
                                            '+',
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
