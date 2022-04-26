import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterdrop_supplier/helper/constants.dart';
import 'package:waterdrop_supplier/helper/helper.dart';
import 'package:waterdrop_supplier/views/register/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

//String baseUrl = 'http://localhost:5000/api/v1';
//String baseUrl = 'http://waterdrop.herokuapp.com/api/v1';
//String baseUrl = 'http://192.168.1.2:5000/api/v1';
/*String baseUrl =
    'https://indiwater-server-i3f5byxu7a-el.a.run.app/api/v1'; //Development API*/

String baseUrl =
    "https://waterdrop-server-v2-devlopment-i3f5byxu7a-el.a.run.app/api/v1";

/*String baseUrl =
    "https://waterdrop-server-v2-production-i3f5byxu7a-el.a.run.app/api/v1";*/
/*String baseUrl =
    'https://indiwater-server-production-i3f5byxu7a-el.a.run.app/api/v1';*/ //Production API

final _firebaseMessaging = FirebaseMessaging.instance;

class DataBaseMethods {
  Future<dynamic> registerStore() async {
    final token = await _firebaseMessaging.getToken();
    String endPoint = '/auth/locations/register';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> officeAddress = {
      'officeNumber': supplier.storeBuildingNo ?? '',
      'landmark': supplier.storeLandmark ?? '',
      'street': supplier.storeColony ?? '',
      'city': supplier.storeCity ?? '',
      'state': supplier.storeState ?? '',
      'country': 'India',
      'pincode': supplier.storePincode ?? ''
    };

    Map<String, dynamic> supplierDetails = {
      "locationFirebaseToken": token,
      'ownerName': supplier.ownerName ?? '',
      'ownerPhoneNumber': supplier.storePhNo ?? '2',
      'ownerOfficeAddress': officeAddress,
      'ownerAadharNumber': supplier.aadhar ?? '',
      'ownerEmail': supplier.ownerEmail ?? '',
      'ownerPanNumber': supplier.panNo ?? '',
      'ownerPanName': supplier.panName ?? '',
      'ownerPanAddress': '',
      'ownerGSTNumber': supplier.gstNo ?? '',
      'storeName': supplier.storeName ?? '',
      'storeEmail': supplier.ownerEmail ?? '',
      'storePhoneNumber': supplier.storePhNo ?? '',
      'storeOfficeAddress': officeAddress,
      'securityDepositAmount': supplier.depositAmount ?? '',
      'storeBankAccountNumber': supplier.bankAccNo ?? '',
      'storeBankAccountType': supplier.accType ?? '',
      'storeBankIFSCCode': supplier.ifscCode ?? '',
      'storeUPI': supplier.upiId ?? '',
      'latitude': supplier.storeLatitude ?? '',
      'longitude': supplier.storeLongitude ?? '',
      'password': supplier.password,
      'confirmPassword': supplier.confirmPassword,
      'locationCode': '1234',
      'slot1Start': supplier.slotOneStartHour,
      'slot2Start': supplier.slotTwoStartHour,
      'slot1End': supplier.slotOneEndHour,
      'slot2End': supplier.slotTwoEndHour,
      'fastDeliveryCharges': supplier.fastDeliveryCharges
    };
    var result;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        body: jsonEncode(supplierDetails),
        headers: Constants.headersMap,
      );
      result = jsonDecode(response.body);
      if (result['success']) {
        showToastNotification(result['message']);
        return result['data'];
      } else {
        showToastNotification(result['message']);
        return {'success': false};
      }
    } catch (e) {
      showToastNotification(result['message']);
      return {'success': false};
    }
  }

  Future<dynamic> logIn(password, phoneNo) async {
    final token = await _firebaseMessaging.getToken();
    String endPoint = '/auth/locations/login';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> logInDetails = {
      "password": password,
      "phone": phoneNo,
      "locationFirebaseToken": token
    };
    var result;
    try {
      final response = await http.post(Uri.parse(finalUrl),
          headers: Constants.headersMap, body: jsonEncode(logInDetails));
      result = jsonDecode(response.body);
      if (result['success'])
        return result['data'];
      else {
        //TODO: Show Toast Notification
        showToastNotification(result['message']);
        return result['data'];
      }
    } catch (e) {
      showToastNotification(result['message']);
      return result['data'];
    }
  }

  Future<List<Map<String, dynamic>>> fetchListedItems() async {
    List<Map<String, dynamic>> listedItems = [];
    final locationId = Constants.myLocationId;
    String endPoint = '/products/location/$locationId';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        listedItems.add(map);
      }
      return listedItems;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchTodaysStatistics(date) async {
    Map<String, dynamic> supplierStats = {};
    //TODO:
    String endPoint = '/statistics/location/${Constants.myLocationId}';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> dateMap = {'date': date};
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(dateMap),
      );
      final result = jsonDecode(response.body);
      //print(result);
      supplierStats = result['data'];
      return supplierStats;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchStatisticsByMonthAndYear(
      month, year) async {
    Map<String, dynamic> supplierStats = {};
    //TODO:
    String endPoint =
        '/statistics/location/${Constants.myLocationId}/each-month';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> dateMap = {'month': month, 'year': year};
    print("------------------");
    print(dateMap);
    print("--------------------");
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(dateMap),
      );
      final result = jsonDecode(response.body);
      supplierStats = result['data'][0];
      return supplierStats;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchStatisticsByDay(date) async {
    Map<String, dynamic> supplierStats = {};
    //TODO:
    String endPoint = '/statistics/location/${Constants.myLocationId}/each-day';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> dateMap = {'date': date};
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(dateMap),
      );
      final result = jsonDecode(response.body);
      supplierStats = result['data'][0];
      return supplierStats;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchStatisticsByYear(year) async {
    Map<String, dynamic> supplierStats = {};
    //TODO:
    String endPoint =
        '/statistics/location/${Constants.myLocationId}/each-year';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> dateMap = {'year': year};
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(dateMap),
      );
      final result = jsonDecode(response.body);
      supplierStats = result['data'][0];
      return supplierStats;
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> fetchGraphStatisticsByYear() async {
    List<Map<String, dynamic>> supplierStats = [];
    //TODO:
    String endPoint = '/statistics/location/${Constants.myLocationId}/year';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
      );
      final result = jsonDecode(response.body);
      for (var map in result['data']) supplierStats.add(map);
      return supplierStats;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchGraphStatisticsByMonth(year) async {
    Map<String, dynamic> yearDetails = {'year': int.parse(year)};
    List<Map<String, dynamic>> supplierStats = [];
    //TODO:
    String endPoint = '/statistics/location/${Constants.myLocationId}/month';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(Uri.parse(finalUrl),
          headers: Constants.headersMap, body: jsonEncode(yearDetails));
      final result = jsonDecode(response.body);
      for (var map in result['data']) supplierStats.add(map);
      return supplierStats;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchGraphStatisticsByWeek(
      startDate, endDate) async {
    Map<String, dynamic> weekDetails = {
      'startDate': startDate.toString(),
      'endDate': endDate.toString()
    };
    List<Map<String, dynamic>> supplierStats = [];
    //TODO:
    String endPoint = '/statistics/location/${Constants.myLocationId}/week';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(Uri.parse(finalUrl),
          headers: Constants.headersMap, body: jsonEncode(weekDetails));
      final result = jsonDecode(response.body);
      for (var map in result['data']) supplierStats.add(map);
      return supplierStats;
    } catch (e) {
      print(e);
      print('error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDeliveryBoys() async {
    List<Map<String, dynamic>> deliveryBoys = [];
    final locationId =
        Constants.myLocationId; // this will come from private local storage

    String endPoint = '/employees/location/${locationId}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        if (!map['isDeleted']) deliveryBoys.add(map);
      }
      return deliveryBoys;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAvailableDeliveryBoys() async {
    List<Map<String, dynamic>> deliveryBoys = [];
    final locationId =
        Constants.myLocationId; // this will come from private local storage

    String endPoint = '/employees/locations/${locationId}/available';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        if (map['available'] && !map['isDeleted']) deliveryBoys.add(map);
      }
      return deliveryBoys;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, int>> fetchVehicles() async {
    Map<String, int> vehicles = {};
    //TODO:
    await Future.delayed(const Duration(seconds: 1));
    vehicles = {'2 Wheeler': 0, '3 Wheeler': 0, '4 Wheeler': 2};
    return vehicles;
  }

  Future<List<Map<String, dynamic>>> fetchCustomerInfo() async {
    //Constants.headersMap['authorization'] = Constants.myToken;
    List<Map<String, dynamic>> customerInfo = [];
    final locationId = Constants.myLocationId;

    String endPoint = '/users/locations/${locationId}';
    String finalUrl = baseUrl + endPoint;
    Constants.headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Constants.myToken,
    };

    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        customerInfo.add(map);
      }
      return customerInfo;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchParticularCustomerInfo(userId) async {
    //Constants.headersMap['authorization'] = Constants.myToken

    String endPoint = '/users/${userId}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      return result['data'];
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderReceived(
      formatedDate, slotTime, page, limit) async {
    var currDt = DateTime.now();
    var todaysFormattedDate = DateFormat('yyyy-MM-dd').format(currDt);
    List<Map<String, dynamic>> orderReceived = [];
    HelperFunctions helperFunctions = HelperFunctions();
    String slotOne =
        helperFunctions.parseDateTime(Constants.slot1StartTime, false) +
            ' to ' +
            helperFunctions.parseDateTime(Constants.slot1EndTime, false);
    // String slotTwo = helperFunctions.parseDateTime(Constants.slot2StartTime, false) + ' to ' + helperFunctions.parseDateTime(Constants.slot2EndTime, false);
    final locationId = Constants.myLocationId;
    Constants.headersMap = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Constants.myToken,
    }; // will be fetched from private local storage (where location details will be saved after login)
    if (slotTime == 'All Time') {
      /* print("------------------");
      print(formatedDate);
      print(limit);
      print(page);
      print("-------------------");*/
      String endPoint =
          '/orders/filter/location/${locationId}?startDate=${formatedDate}&page=${page}&limit=${limit}';
      print(endPoint);
      String finalUrl = baseUrl + endPoint;
      try {
        final response = await http.get(Uri.parse(finalUrl), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Constants.myToken
        });
        final result = jsonDecode(response.body);
        for (var map in result['data']) {
          if (map['status'] == 'CANCELLED') {
            continue;
          }
          if (todaysFormattedDate == formatedDate) {
            if (map['status'] == 'DELIVERED') {
              continue;
            }
          }
          orderReceived.add(map);
        }
        return orderReceived;
      } catch (e) {
        print(e);
        return [];
      }
    } else {
      String endPoint = '/orders/location/${locationId}/slot';
      String finalUrl = baseUrl + endPoint;
      String slot = 'slot2';
      if (slotTime == slotOne) slot = 'slot1';
      Map<String, dynamic> body = {'date': formatedDate, 'slot': slot};
      try {
        final response = await http.post(Uri.parse(finalUrl),
            headers: Constants.headersMap, body: jsonEncode(body));
        final result = jsonDecode(response.body);
        for (var map in result['data']) {
          if (todaysFormattedDate == formatedDate) {
            if (map['status'] == 'DELIVERED') {
              continue;
            }
          }
          orderReceived.add(map);
        }
        return orderReceived;
      } catch (e) {
        print(e);
        return [];
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchUrgentOrders(formatedDate) async {
    List<Map<String, dynamic>> urgentOrders = [];
    final locationId = Constants
        .myLocationId; // will be fetched from private local storage (where location details will be saved after login)
    var result;
    String endPoint =
        '/orders/filter/location/${locationId}?urgency=URGENT&startDate=${formatedDate}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      result = jsonDecode(response.body);
      for (var map in result['data']) {
        if (map['status'] == 'DELIVERED' || map['status'] == 'CANCELLED')
          continue;
        urgentOrders.add(map);
      }
      return urgentOrders;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDeliveredOrders() async {
    List<Map<String, dynamic>> deliveredOrders = [];
    var currDt = DateTime.now();
    var todaysFormattedDate = DateFormat('yyyy-MM-dd').format(currDt);
    final locationId = Constants
        .myLocationId; // will be fetched from private local storage (where location details will be saved after login)
    String endPoint =
        '/orders/filter/location/${locationId}?status=DELIVERED&startDate=$todaysFormattedDate';

    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        deliveredOrders.add(map);
      }
      return deliveredOrders;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchNotDeliveredOrders() async {
    List<Map<String, String>> notDeliveredOrders = [];
    //TODO:
    final locationId = Constants
        .myLocationId; // will be fetched from private local storage (where location details will be saved after login)

    String endPoint =
        '/orders/filter/location/${locationId}?status="ON_THE_WAY"';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.get(
        Uri.parse(finalUrl),
      );
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        notDeliveredOrders.add(map);
      }
      return notDeliveredOrders;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchCancelledOrders() async {
    List<Map<String, dynamic>> cancelledOrders = [];
    var currDt = DateTime.now();
    var todaysFormattedDate = DateFormat('yyyy-MM-dd').format(currDt);
    final locationId = Constants.myLocationId;
    String endPoint =
        '/orders/filter/location/${locationId}?status=CANCELLED&startDate=$todaysFormattedDate'; //TODO:This API needs to be changed

    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.get(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        cancelledOrders.add(map);
      }
      return cancelledOrders;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    String endPoint = '/locations/${Constants.myLocationId}/notifications';
    String finalUrl = baseUrl + endPoint;
    List<Map<String, dynamic>> notifications = [];
    try {
      final response = await http.get(Uri.parse(finalUrl));
      final result = jsonDecode(response.body);
      if (result['success']) {
        for (var map in result['data']) notifications.add(map);
        return notifications;
      }
      return [];
    } catch (e) {
      return [];
    }
    //TODO:

    await Future.delayed(const Duration(seconds: 1));
    return notifications;
  }

  Future<List<Map<String, dynamic>>> fetchCustomerOrders(
      String? customerId, selectedDate) async {
    List<Map<String, dynamic>> customerOrders = [];

    final locationId = Constants.myLocationId;

    String endPoint = '/orders/location/${locationId}/user/${customerId}';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> body = {'date': selectedDate};
    try {
      final response = await http.post(Uri.parse(finalUrl),
          headers: Constants.headersMap, body: jsonEncode(body));
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        customerOrders.add(map);
      }
      return customerOrders;
    } catch (e) {
      print(e);
    }
    //TODO:

    await Future.delayed(const Duration(seconds: 1));
    return customerOrders;
  }

  fetchOrdersDeliveredByParticularDeliveryBoy(
      String? deliveryBoyId, selectedDate) async {
    List<Map<String, dynamic>> ordersDelivered = [];

    //String endPoint = '/orders/getAllOrdersByDeliveryBoyId/${deliveryBoyId}';
    String endPoint = '/orders/employee/${deliveryBoyId}';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> body = {'date': selectedDate};
    try {
      final response = await http.post(Uri.parse(finalUrl),
          headers: Constants.headersMap, body: jsonEncode(body));
      final result = jsonDecode(response.body);
      for (var map in result['data']) {
        if (map['status'] == 'DELIVERED') {
          ordersDelivered.add(map);
        }
      }
      return ordersDelivered;
    } catch (e) {
      print(e);
    }
    //TODO:

    return ordersDelivered;
  }

  Future<bool> changeDeliveryBoyStatus(employeeId, isAvailable) async {
    String endPoint = '/employees/${employeeId}/status';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(Uri.parse(finalUrl),
          headers: Constants.headersMap,
          body: jsonEncode({'status': isAvailable}));
      final result = jsonDecode(response.body);
      return result['success'];
      //showToastNotification(jsonDecode(response.body)['message']);
    } catch (e) {
      return false;
    }
  }

  changeDeliveryBoyOfParticularOrder(orderId, newDeliveryBoyId) async {
    String endPoint = '/orders/${orderId}/employee/${newDeliveryBoyId}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.put(Uri.parse(finalUrl), headers: Constants.headersMap);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> addDeliveryBoy(deliveryBoyDetailsMap) async {
    String endPoint = '/auth/employees/register';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(deliveryBoyDetailsMap),
      );
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
      if (result['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editDeliveryBoy(deliveryBoyDetailsMap, deliveryBoyId) async {
    String endPoint =
        '/locations/${Constants.myLocationId}/employee/$deliveryBoyId';
    print(deliveryBoyDetailsMap);
    print('!!!!!!!!!');
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(deliveryBoyDetailsMap),
      );
      final result = jsonDecode(response.body);
      print(result);
      showToastNotification(result['message']);
      if (result['success']) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> addItem(itemDetailsMap) async {
    Map<String, dynamic> itemDetails = {};
    String endPoint = '/products';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(itemDetailsMap),
      );
      final result = jsonDecode(response.body);
      print(result);
      itemDetails = result['data'];
      return itemDetails;
    } catch (e) {
      print(e);
      return {};
    }
  }

  generateForgetPasswordOTP(phoneNo) async {
    Map<String, dynamic> details = {'phone': phoneNo};
    String endPoint = '/auth/locations/forgot-password';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(details),
      );
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
    } catch (e) {
      print(e);
      showToastNotification(e.toString());
    }
  }

  generateOTP(phoneNo) async {
    Map<String, dynamic> details = {'phone': phoneNo};
    String endPoint =
        '/auth/locations/${Constants.myLocationId}/send-phone-update-otp';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(details),
      );
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
    } catch (e) {
      print(e);
      showToastNotification(e.toString());
    }
  }

  generateVerifySupplierOTP(phoneNo) async {
    Map<String, dynamic> details = {'phone': phoneNo};
    String endPoint = '/auth/locations/verify-location';

    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(details),
      );
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
    } catch (e) {
      print(e);
      showToastNotification(e.toString());
    }
  }

  Future<bool> verifyOTP(phoneNo, enteredOTP) async {
    Map<String, dynamic> details = {'phone': phoneNo, 'code': enteredOTP};
    String endPoint = '/auth/locations/forgot-password/verify';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(details),
      );
      final result = jsonDecode(response.body);
      if (result['success']) {
        showToastNotification(result['message']);
        return true;
      } else {
        showToastNotification(result['message']);
        return false;
      }
    } catch (e) {
      print(e);
      showToastNotification(e.toString());
      return false;
    }
  }

  Future<bool> verifyPhoneUpdateOTP(phoneNo, enteredOTP) async {
    Map<String, dynamic> details = {'phone': phoneNo, 'code': enteredOTP};
    String endPoint =
        '/auth/locations/${Constants.myLocationId}/verify-phone-update-otp';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(details),
      );
      final result = jsonDecode(response.body);
      if (result['success']) {
        showToastNotification('Phone Number Updated');
        return true;
      } else {
        showToastNotification(result['message']);
        return false;
      }
    } catch (e) {
      print(e);
      showToastNotification(e.toString());
      return false;
    }
  }

  Future<bool> deleteSelectedItem(productId) async {
    String endPoint = '/products/${productId}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.delete(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteSelectedDeliveryPartner(deliveryPartnerId) async {
    String endPoint = '/employees/${deliveryPartnerId}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response =
          await http.delete(Uri.parse(finalUrl), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  changePassword(phoneNo, newPassword) async {
    String endPoint = '/auth/locations/update-password';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> body = {'phone': phoneNo, 'password': newPassword};
    try {
      final response = await http.put(Uri.parse(finalUrl),
          headers: Constants.headersMap, body: jsonEncode(body));
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
    } catch (e) {
      print(e);
    }
  }

  editItemDetails(id, details) async {
    print(details);
    String endPoint = '/products/${id}';
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(details),
      );
      final result = jsonDecode(response.body);
      print(result);
      showToastNotification(result['message']);
    } catch (e) {}
  }

  Future<bool> changeOrderStatusToDelivered(
      orderId, emptyCans, amountReceived) async {
    String endPoint = "/orders/${orderId}/delivered";
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> orderDetails = {
      "emptyCans": int.parse(emptyCans),
      "cashCollected": int.parse(amountReceived)
    };
    /*Map<String, dynamic> orderDetails = {
      "cansReturned": int.parse(emptyCans),
      "cashReceived": int.parse(amountReceived)
    };*/
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(orderDetails),
      );
      final result = jsonDecode(response.body);
      print(result);
      showToastNotification(result['message']);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateLocation(newData) async {
    String endPoint = "/locations/${Constants.myLocationId}";
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(newData),
      );
      final result = jsonDecode(response.body);
      print(result);
      showToastNotification(result['message']);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateLocationFinanceDetails(newData) async {
    String endPoint = "/locations/${Constants.myLocationId}/finance";
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(newData),
      );
      final result = jsonDecode(response.body);
      print(result);
      showToastNotification(result['message']);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeCansEngagedByParticularUser(userId, cansEngaged) async {
    String endPoint = '/users/${userId}/cans-engaged';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> body = {'cansEngaged': cansEngaged};
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(body),
      );
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeWalletBalanceOfParticularUser(
      userId, walletBalance) async {
    String endPoint = '/users/${userId}/wallet';
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> body = {'newWalletBalance': walletBalance};
    try {
      final response = await http.put(
        Uri.parse(finalUrl),
        headers: Constants.headersMap,
        body: jsonEncode(body),
      );
      final result = jsonDecode(response.body);
      showToastNotification(result['message']);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> initsiateTransaction(amount) async {
    String endpoint = "/payment";
    String finalUrl = baseUrl + endpoint;
    Map<String, dynamic> body = {'amount': double.parse(amount).toString()};
    final response = await http.post(Uri.parse(finalUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body));
    final result = jsonDecode(response.body);
    await processTransaction(result, amount);
    return result['data'];
  }

  processTransaction(data, amount) async {
    String endpoint = '/payment/process';
    String finalUrl = baseUrl + endpoint;
    Map<String, dynamic> body = {
      'txnToken': data['data']['body']['txnToken'],
      'orderId': data['orderId'],
      'payerAccount': '7978589602@paytm'
    };
    final response = await http.post(Uri.parse(finalUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body));
    final result = jsonDecode(response.body);
  }

  Future<bool> logOut() async {
    String endPoint = "/auth/locations/${Constants.myLocationId}/logout";
    String finalUrl = baseUrl + endPoint;

    try {
      final response = await http.put(Uri.parse(finalUrl));
      final result = jsonDecode(response.body);
      if (result['success'] == false) {
        showToastNotification(result['message']);
      }
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  showToastNotification(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<Map<String, dynamic>> getAppURL() async {
    String endPoint = "/appVersion/supplier";
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.get(Uri.parse(finalUrl));
      final result = jsonDecode(response.body);
      print(result);
      if (result["success"] == false) {
        showToastNotification(result['message']);
        return {};
      }
      // print(result);
      return result['data'];
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> requestForHelp(String msg) async {
    String endPoint = "/support";
    String finalUrl = baseUrl + endPoint;
    Map<String, dynamic> body = {
      'entityId': Constants.myLocationId,
      'description': msg,
      'entityType': "LOCATION"
    };
    try {
      final response = await http.post(Uri.parse(finalUrl),
          body: jsonEncode(body), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      print(result);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> cancelOrder(mongoId, body) async {
    print(mongoId);
    String endPoint = "/orders/$mongoId/cancel";
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.put(Uri.parse(finalUrl),
          body: jsonEncode(body), headers: Constants.headersMap);
      final result = jsonDecode(response.body);
      print(result);
      showToastNotification(result['message']);
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<String>> fetchBrandName() async {
    List<String> brandNames = [];
    final endPoint = "/brands";
    String finalUrl = baseUrl + endPoint;
    try {
      final response = await http.get(Uri.parse(finalUrl));
      final result = jsonDecode(response.body);
      if (result['success'] == false) {
        showToastNotification(result['message']);
        return [];
      }
      for (var map in result['data']) {
        brandNames.add(map['name']);
      }
      return brandNames;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Map<String, dynamic>> checkNecessaryUpdate() async {
    final endPoint = "/app-update?name=SUPPLIER";
    final finalUrl = baseUrl + endPoint;
    try {
      final response = await http.get(Uri.parse(finalUrl));
      final result = jsonDecode(response.body);
      // print(result['data'][0]);
      //if(result['succ'])
      return result['data'][0];
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> addCustomer(customerDetails) async {
    final endPoint = "/auth/users/register";
    final finalUrl = baseUrl + endPoint;
    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        body: jsonEncode(customerDetails),
        headers: Constants.headersMap,
      );
      final result = jsonDecode(response.body);
      if (result['success'] == false) {
        showToastNotification(result['message']);
      }
      return result['success'];
    } catch (e) {
      print(e);
      return false;
    }
  }
}
