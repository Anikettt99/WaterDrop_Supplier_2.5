import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/model/bar_model.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:waterdrop_supplier/custom_package/month_picker.dart';
import '../notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../view_qr_code.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  Map<String, dynamic> supplierStats = {};
  Map<String, dynamic> todaysStats = {};
  Map<String, dynamic> customStats = {};
  bool loading = true;
  String? initialDayAndMonth, finalDayAndMonth, customDayAndMonth;
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();
  var sortByItems = ['By Year', 'By Month', 'By Week'];
  String sortByValue = 'By Month';
  var yearDropDownItems = ['2021', '2022', '2023'];
  String yearDropDownValue = '2022';
  var monthDropDownItems = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  int? monthNumber = DateTime.now().month;
  String? monthDropDownValue;
  String? currentMonthNumber, currentMonthName;
  var initialDate, finalDate, selectedDate;
  List<Map<String, dynamic>> graphData = [];
  List<BarModel> graphDisplayData = [];
  int totalOrders = 0;


  @override
  void initState() {
    var currDt = DateTime.now();
    initialDate = currDt;
    finalDate = currDt.add(Duration(days: 6));;
    selectedDate = initialDate;
    customDayAndMonth = findDayAndMonth(initialDate);
    // print(currDt);
    var formatedDate = DateFormat('yyyy-MM-dd').format(currDt);
    // TODO: implement initState
    setState(() {
      loading = true;
      monthDropDownValue = currDt.toString().substring(5, 7);
      monthDropDownValue =
          helperFunctions.findMonthNameFromMonthNumber(monthDropDownValue);
    });
    dataBaseMethods
        .fetchTodaysStatistics(formatedDate.toString())
        .then((value) {
      dataBaseMethods
          .fetchStatisticsByMonthAndYear(currDt.month, currDt.year)
          .then((value2) {
        updateMonthGraphStats();
        setState(() {
          customStats = value2;
          totalOrders = getTotalOrders();
          todaysStats = value;
          loading = false;
        });
      });
    });
    super.initState();
  }

  updateData(val) {
    //   print('called');
    dataBaseMethods
        .fetchStatisticsByMonthAndYear(monthNumber, int.parse(val))
        .then((value) {
      setState(() {
        loading = false;
        customStats = value;
        totalOrders = getTotalOrders();
      });
    });
  }

  updateYearStats(val) {
    dataBaseMethods.fetchStatisticsByYear(int.parse(val)).then((value) {
      setState(() {
        loading = false;
        customStats = value;
        totalOrders = getTotalOrders();
      });
    });
  }

  updateYearGraphStats() async {
    await dataBaseMethods.fetchGraphStatisticsByYear().then((value) {
      if(value[0]['years'].length == 0){
        graphDisplayData = [];
        BarModel firstModel = BarModel(0, '2021');
        BarModel secondModel = BarModel(0, '2022');
        BarModel thirdModel = BarModel(0, '2023');
        graphDisplayData.add(firstModel);
        graphDisplayData.add(secondModel);
        graphDisplayData.add(thirdModel);
        setState(() {

        });
        return;
      }
      graphData = value;
      graphDisplayData = [];
      BarModel firstModel = BarModel(0, '2021');
      print(value);
      graphDisplayData.add(firstModel);
      for (var map in graphData[0]['years']) {
        BarModel barModel =
            BarModel(map['totalAmount'], map['year'].toString());
        graphDisplayData.add(barModel);
      }
      BarModel lastModel = BarModel(0, '2023');
      graphDisplayData.add(lastModel);
      setState(() {});
    });
  }

  updateMonthGraphStats() async {
    await dataBaseMethods
        .fetchGraphStatisticsByMonth(yearDropDownValue)
        .then((value) {
      graphDisplayData = [];
      graphDisplayData = helperFunctions.getBarModelOfEachMonth(value);
      setState(() {});
    });
  }

  updateWeekGraphStats() async {
    var formattedInitialDate, formattedFinalDate;
    formattedInitialDate = DateFormat('yyyy-MM-dd').format(initialDate);
    formattedFinalDate = DateFormat('yyyy-MM-dd').format(finalDate);
    await dataBaseMethods
        .fetchGraphStatisticsByWeek(formattedInitialDate, formattedFinalDate)
        .then((value) {
      graphDisplayData = [];
      graphDisplayData = helperFunctions.getBarModelOfEachDayOfWeek(
          initialDate, finalDate, value[0]);
      setState(() {});
    });
  }

  updateWeekStats(val) {
    var formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    dataBaseMethods.fetchStatisticsByDay(formattedDate).then((value) {
      setState(() {
        loading = false;
        customStats = value;
        totalOrders = getTotalOrders();
      });
    });
  }

  int getTotalOrders() {
    int total = 0;
    int deliveredOrders = customStats['delivered_orders'].length == 0
        ? 0
        : customStats['delivered_orders'][0]['count'];
    int notDeliveredOrders = customStats['not_delivered_orders'].length == 0
        ? 0
        : customStats['not_delivered_orders'][0]['count'];
    total = deliveredOrders + notDeliveredOrders;
    return total;
  }

  Widget _handleDropDown() {
    initialDayAndMonth = findDayAndMonth(initialDate);
    finalDayAndMonth = findDayAndMonth(finalDate);
    return sortByValue == 'By Month'
        ? Card(
            elevation: 3,
            child: Container(
              padding: EdgeInsets.only(left: 30, right: 1),
              // width: 80,
              height: 30,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    dropdownColor: Colors.white,
                    elevation: 3,
                    iconSize: 32,
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                    ),
                    value: yearDropDownValue,
                    items: yearDropDownItems.map((String items) {
                      return DropdownMenuItem(value: items, child: Text(items));
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        yearDropDownValue = newValue.toString();
                        updateMonthGraphStats();
                        updateData(newValue);
                      });
                    }),
              ),
            ),
          )
        : sortByValue == 'By Year'
            ? Card(
                elevation: 3,
                child: Container(
                  height: 30,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: const Center(
                    child: Text(
                      '2021 - 2023',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2025),
                          helpText: 'Select First Date of Week')
                      .then((value) {
                    if (value == null) return;
                    initialDate = value;
                    finalDate = initialDate.add(Duration(days: 6));
                    setState(() {
                      initialDayAndMonth = findDayAndMonth(initialDate);
                      finalDayAndMonth = findDayAndMonth(finalDate);
                      updateWeekGraphStats();
                      customDayAndMonth = initialDayAndMonth;
                      selectedDate = initialDate;
                    });
                  });
                },
                child: Card(
                  elevation: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: 30,
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                            initialDayAndMonth! + ' - ' + finalDayAndMonth!,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }

  findDayAndMonth(date) {
    String res = date.day.toString() +
        ' ' +
        helperFunctions
            .findMonthNameFromMonthNumber(date.toString().substring(5, 7));
    return res;
  }

  Widget yearDropDownCard() {
    return Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.only(left: 30, right: 1),
        // width: 80,
        height: 30,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              dropdownColor: Colors.white,
              elevation: 3,
              iconSize: 32,
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.black,
              ),
              value: yearDropDownValue,
              items: yearDropDownItems.map((String items) {
                return DropdownMenuItem(value: items, child: Text(items));
              }).toList(),
              onChanged: (newValue) {
                if (newValue == yearDropDownValue) {
                  return;
                }
                setState(() {
                  yearDropDownValue = newValue.toString();
                  updateYearStats(yearDropDownValue);
                });
              }),
        ),
      ),
    );
  }

  List<charts.Series<BarModel, String>> _createSampleData() {

    return [
      charts.Series<BarModel, String>(
        data: graphDisplayData,
        id: 'Statistics',
        colorFn: (_, __) => charts.Color.fromHex(code: '#006BFFFF'),
        domainFn: (BarModel barModel, _) => barModel.year,
        measureFn: (BarModel barModel, _) => barModel.value,
      )
    ];
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
          ? Center(child: CircularProgressIndicator(color: primaryColor,))
          : supplierStats.length != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/no_stats.png'),
                              fit: BoxFit.fill)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'No stats to show yet',
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  width: 100,
                                  height: 30,
                                  child: const Center(
                                    child: Text(
                                      'Today',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  'TOTAL ORDERS\nRECEIVED:',
                                  todaysStats['totalOrdersReceived']
                                      .toString()),
                            ),
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  'TOTAL ITEMS\nDELIVERED:',
                                  todaysStats['totalDeliveredOrders']
                                      .toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  'TOTAL ITEMS NOT\nDELIVERED:',
                                  todaysStats['totalNotDeliveredOrders']
                                      .toString()),
                            ),
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  'TODAY\'S\nEARNINGS:',
                                  '₹' +
                                      todaysStats['totalEarnings'].toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              elevation: 3,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 1),
                                height: 30,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      dropdownColor: Colors.white,
                                      elevation: 3,
                                      iconSize: 32,
                                      icon: Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: Colors.black,
                                      ),
                                      value: sortByValue,
                                      items: sortByItems.map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        if (newValue == sortByValue) {
                                          return;
                                        }
                                        setState(() {
                                          sortByValue = newValue.toString();
                                          if (sortByValue == 'By Year') {
                                            updateYearGraphStats();
                                            updateYearStats(yearDropDownValue);
                                          } else if (sortByValue ==
                                              'By Month') {
                                            updateMonthGraphStats();
                                            updateData(yearDropDownValue);
                                          } else {
                                            updateWeekGraphStats();
                                            updateWeekStats('');
                                          }
                                        });
                                      }),
                                ),
                              ),
                            ),
                            _handleDropDown()
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          // height: 200,
                          child: sortByValue == 'By Month'
                              ? SizedBox(
                                height: width * 0.6,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15, left: 5),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: width,
                                            height: width * 0.6,
                                            child: charts.BarChart(
                                              _createSampleData(),
                                              animate: true,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: width,
                                    height: width * 0.6,
                                    child: charts.BarChart(
                                      _createSampleData(),
                                      animate: true,
                                    ),
                                  )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sortByValue == 'By Week'
                                  ? '  Day ' + 'Details'
                                  : '  ' +
                                      sortByValue.split(' ')[1] +
                                      ' Details',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            sortByValue == 'By Month'
                                ? GestureDetector(
                                    onTap: () {
                                      showMonthPickerCustom(
                                              context: context,
                                              initialDate: DateTime(
                                                  int.parse(yearDropDownValue),
                                                  monthNumber!))
                                          .then((value) {
                                        String selectedMonth = helperFunctions
                                            .findMonthNameFromMonthNumber(value
                                                .toString()
                                                .substring(5, 7));
                                        if (value == null ||
                                            selectedMonth == monthDropDownValue)
                                          return;
                                        dataBaseMethods
                                            .fetchStatisticsByMonthAndYear(
                                                value.month,
                                                int.parse(yearDropDownValue))
                                            .then((value2) {
                                          setState(() {
                                            monthNumber = value.month;
                                            customStats = value2;
                                            totalOrders = getTotalOrders();
                                            monthDropDownValue = selectedMonth;
                                            loading = false;
                                          });
                                        });
                                      });
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 1),
                                          height: 30,
                                          width: 100,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                monthDropDownValue!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17),
                                              ),
                                              Icon(Icons.arrow_drop_down)
                                            ],
                                          )),
                                    ),
                                  )
                                : sortByValue == 'By Year'
                                    ? yearDropDownCard()
                                    : GestureDetector(
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: initialDate,
                                                  lastDate: finalDate)
                                              .then((value) {
                                            if (value == null) return;
                                            selectedDate = value;
                                            customDayAndMonth =
                                                findDayAndMonth(selectedDate);
                                            updateWeekStats('');
                                          });
                                        },
                                        child: Card(
                                            elevation: 3,
                                            child: Container(
                                              height: 30,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 2),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      customDayAndMonth!,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(Icons.arrow_drop_down)
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: customStatsCard(100.0, width * 0.38,
                                  'TOTAL ORDERS: \n', totalOrders.toString()),
                            ),
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  'TOTAL ITEMS\nDELIVERED:',
                                  customStats['delivered_orders'].length == 0
                                      ? '0'
                                      : customStats['delivered_orders'][0]
                                              ['count']
                                          .toString()),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  'TOTAL ITEMS NOT\nDELIVERED:',
                                  customStats['not_delivered_orders'].length ==
                                          0
                                      ? '0'
                                      : customStats['not_delivered_orders'][0]
                                              ['count']
                                          .toString()),
                            ),
                            Container(
                              child: customStatsCard(
                                  100.0,
                                  width * 0.38,
                                  sortByValue == 'Custom'
                                      ? 'EARNING\'S\n'
                                      : 'EARNING\'S\nTHIS ' +
                                          sortByValue
                                              .split(' ')[1]
                                              .toUpperCase(),
                                  customStats['delivered_orders'].length == 0
                                      ? '₹0'
                                      : '₹' +
                                          customStats['delivered_orders'][0]
                                                  ['totalAmount']
                                              .toString()),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
