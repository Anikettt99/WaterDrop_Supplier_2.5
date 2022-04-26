import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterdrop_supplier/model/bar_model.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferencePhoneNumberKey = "PHONENUMBERKEY";
  static String sharedPreferenceUserTokenKey = "USERTOKENKEY";
  static String sharedPreferenceLocationIdKey = "LOCATIONIDKEY";
  static String sharedPreferenceSupplierIdKey = "SUPPLIERIDKEY";
  static String sharedPreferenceUserMailIdKey = "USERMAILIDKEY";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceStoreNameKey = "STORENAMEKEY";
  static String sharedPreferenceUserCodeKey = "USERCODEKEY";
  static String sharedPreferenceUserQrCodeLinkKey = "USERQRCODELINKKEY";
  static String sharedPreferenceUserAddressKey = "USERADDRESSKEY";
  static String sharedPreferenceUserShortAddressKey = "USERSHORTADDRESSKEY";
  static String sharedPreferenceUserSlot1StartTime = "USERSLOT1STARTTIME";
  static String sharedPreferenceUserSlot2StartTime = "USERSLOT2STARTTIME";
  static String sharedPreferenceUserSlot1EndTime = "USERSLOT1ENDTIME";
  static String sharedPreferenceUserSlot2EndTime = "USERSLOT2ENDTIME";
  static String sharedPreferenceSecurityDepositAmountKey = "SECURITYAMOUNTKEY";
  static String sharedPreferenceAadharCardNumberkey = "AADHARCARDKEY";
  static String sharedPreferencePanCardNumberKey = "PANCARDKEY";
  static String sharedPreferenceGSTNumberKey = "GSTNUMBERKEY";
  static String sharedPreferenceFastDeliveryChargeKey = "FASTDELIVERYCHARGEKEY";

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> savePhoneNumberSharedPreference(int phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(sharedPreferencePhoneNumberKey, phoneNumber);
  }

  static Future<bool> saveUserTokenSharedPreference(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserTokenKey, userToken);
  }

  static Future<bool> saveLocationIdSharedPreference(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceLocationIdKey, userToken);
  }

  static Future<bool> saveSupplierIdSharedPreference(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceSupplierIdKey, userToken);
  }

  static Future<bool> saveUserMailIdSharedPreference(String userMailId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserMailIdKey, userMailId);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveStoreNameSharedPreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceStoreNameKey, userName);
  }

  static Future<bool> saveUserCodeSharedPreference(String userCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserCodeKey, userCode);
  }

  static Future<bool> saveUserQrCodeLinkSharedPreference(
      String userQrCodeLink) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserQrCodeLinkKey, userQrCodeLink);
  }

  static Future<bool> saveUserAddressSharedPreference(
      String userAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserAddressKey, userAddress);
  }

  static Future<bool> saveUserShortAddressSharedPreference(
      String userShortAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserShortAddressKey, userShortAddress);
  }

  static Future<bool> saveUserSlot1StartTimeSharedPreference(
      String userSlot1StartTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserSlot1StartTime, userSlot1StartTime ?? '');
  }

  static Future<bool> saveUserSlot2StartTimeSharedPreference(
      String userSlot2StartTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserSlot2StartTime, userSlot2StartTime ?? '');
  }

  static Future<bool> saveUserSlot1EndTimeSharedPreference(
      String userSlot1EndTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserSlot1EndTime, userSlot1EndTime ?? '');
  }

  static Future<bool> saveUserSlot2EndTimeSharedPreference(
      String userSlot2EndTime) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceUserSlot2EndTime, userSlot2EndTime ?? '');
  }

  static Future<bool> saveUserSecurityDepositAmountSharedPreference(
      String securityDepositAmount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceSecurityDepositAmountKey, securityDepositAmount);
  }

  static Future<bool> saveUserAadharCardSharedPreference(
      String aadharNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceAadharCardNumberkey, aadharNumber);
  }

  static Future<bool> saveUserPanCardSharedPreference(
      String panNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferencePanCardNumberKey, panNumber);
  }

  static Future<bool> saveUserGSTNumberSharedPreference(
      String GSTNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceGSTNumberKey, GSTNumber);
  }

  static Future<bool> saveUserFastDeliveryChargeSharedPreference(
      String fastDeliveryCharge) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(
        sharedPreferenceFastDeliveryChargeKey, fastDeliveryCharge);
  }

  //Get Data

  static Future<bool?> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<int?> getPhoneNumberSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(sharedPreferencePhoneNumberKey);
  }

  static Future<String?> getUserTokenSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserTokenKey);
  }

  static Future<String?> getLocationIdSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceLocationIdKey);
  }

  static Future<String?> getSupplierIdSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceSupplierIdKey);
  }

  static Future<String?> getUserMailIdSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserMailIdKey);
  }

  static Future<String?> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getStoreNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceStoreNameKey);
  }

  static Future<String?> getUserCodeSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserCodeKey);
  }

  static Future<String?> getUserQrCodeLinkSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserQrCodeLinkKey);
  }

  static Future<String?> getUserAddressSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserAddressKey);
  }

  static Future<String?> getUserShortAddressSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserShortAddressKey);
  }

  static Future<String?> getUserSlot1StartTimeSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserSlot1StartTime);
  }

  static Future<String?> getUserSlot2StartTimeSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserSlot2StartTime);
  }

  static Future<String?> getUserSlot1EndTimeSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserSlot1EndTime);
  }

  static Future<String?> getUserSlot2EndTimeSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserSlot2EndTime);
  }

  static Future<String?> getSecurityDepositAmountSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceSecurityDepositAmountKey);
  }

  static Future<String?> getAadharCardNumberSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceAadharCardNumberkey);
  }

  static Future<String?> getPanCardNumberSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencePanCardNumberKey);
  }

  static Future<String?> getGSTNumberSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceGSTNumberKey);
  }

  static Future<String?> getFastDeliveryChargeSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceFastDeliveryChargeKey);
  }


  String formatDate(String date) {
    DateTime d = DateTime.parse(date);
    String newDate = DateFormat('d MMM, y').format(d);
    //print(nd);
    //String newDate = date.split('-').reversed.join('-');
    return newDate;
  }

  findMonthNameFromMonthNumber(number) {
    String monthName = '';
    switch (number) {
      case '01':
        monthName = 'Jan';
        break;
      case '02':
        monthName = 'Feb';
        break;
      case '03':
        monthName = 'Mar';
        break;
      case '04':
        monthName = 'Apr';
        break;
      case '05':
        monthName = 'May';
        break;
      case '06':
        monthName = 'Jun';
        break;
      case '07':
        monthName = 'Jul';
        break;
      case '08':
        monthName = 'Aug';
        break;
      case '09':
        monthName = 'Sep';
        break;
      case '10':
        monthName = 'Oct';
        break;
      case '11':
        monthName = 'Nov';
        break;
      case '12':
        monthName = 'Dec';
        break;
    }
    return monthName;
  }

  String parseDateTime(String time, bool parseMin) {
    if(time == '0')
      return '12 AM';
    if(time.length == 1){
      return time + ' AM';
    }
    int temp = int.parse(time.split(':').first);

    if (temp >= 12) {
      int hr = temp;
      hr = hr - 12;
      if (hr == 0) hr = 12;
      if (parseMin) {
        int min = int.parse(time.substring(3, 5));
        String minString = min.toString();
        if(minString.length == 1){
          minString = '0' + minString;
        }
        time = hr.toString() + ":" + minString + ' PM';
      } else
        time = hr.toString() + ' PM';
    } else {
      if (temp == 0) {
        time = '12:00';
      }
      else{
        if(!parseMin){
          time = temp.toString();
        }
        else{
          time = temp.toString() + ':00';
        }
      }
      time = time + ' AM';
    }
    return time;
  }

  String summarizeCart(orders) {
    String summarizedCart = '';
    if(orders.length == 0)
      return '';
    for (var order in orders) {
      summarizedCart +=
          order['productQty'].toString() + ' x ' + getItemName(order['productId']) + ', ';
    }
    summarizedCart = summarizedCart.substring(0, summarizedCart.length - 2);
    return summarizedCart;
  }

  String getItemName(itemDetails) {
    String itemName = '';
    if(itemDetails['isDispenser']){
      String dispenserType = itemDetails['isDispenserAutomatic'] ? 'Automatic Pump' : 'Manual Jar';
      String brandName = itemDetails['brandName'] == ' ' ? '' : itemDetails['brandName'];
      itemName = brandName + ' ' + dispenserType + ' Dispenser';
      return itemName;
    }
    if(itemDetails['type'] == 'Water Bottle' || itemDetails['isGeneralProduct']){
      itemName = itemDetails['brandName'] +
          ' ' +
          itemDetails['qtyInLiters'].toString() +
          ' ' +
          itemDetails['type'];
      return itemName;
    }
    itemName = itemDetails['brandName'] +
        ' ' +
        itemDetails['qtyInLiters'].toString() +
        'L ' +
        itemDetails['type'];
    return itemName;
  }

  List<BarModel> getBarModelOfEachMonth(value) {
    int janEarnings = 0,
        febEarnings = 0,
        marEarnings = 0,
        aprEarnings = 0,
        mayEarnings = 0,
        junEarnings = 0,
        julEarnings = 0,
        augEarnings = 0,
        sepEarnings = 0,
        octEarnings = 0,
        novEarnings = 0,
        decEarnings = 0;
    List<BarModel> data = [];
    if (value[0]['january'].length >= 1) {
      janEarnings = value[0]['january'][0]['totalAmount'];
    }
    if (value[0]['february'].length >= 1) {
      febEarnings = value[0]['february'][0]['totalAmount'];
    }
    if (value[0]['march'].length >= 1) {
      marEarnings = value[0]['march'][0]['totalAmount'];
    }
    if (value[0]['april'].length >= 1) {
      aprEarnings = value[0]['april'][0]['totalAmount'];
    }
    if (value[0]['may'].length >= 1) {
      mayEarnings = value[0]['may'][0]['totalAmount'];
    }
    if (value[0]['june'].length >= 1) {
      junEarnings = value[0]['june'][0]['totalAmount'];
    }
    if (value[0]['july'].length >= 1) {
      julEarnings = value[0]['july'][0]['totalAmount'];
    }
    if (value[0]['august'].length >= 1) {
      augEarnings = value[0]['august'][0]['totalAmount'];
    }
    if (value[0]['september'].length >= 1) {
      sepEarnings = value[0]['september'][0]['totalAmount'];
    }
    if (value[0]['october'].length >= 1) {
      octEarnings = value[0]['october'][0]['totalAmount'];
    }
    if (value[0]['november'].length >= 1) {
      novEarnings = value[0]['novemeber'][0]['totalAmount'];
    }
    if (value[0]['december'].length >= 1) {
      decEarnings = value[0]['december'][0]['totalAmount'];
    }
    BarModel barModelJan = BarModel(janEarnings, 'Jan');
    BarModel barModelFeb = BarModel(febEarnings, 'Feb');
    BarModel barModelMar = BarModel(marEarnings, 'Mar');
    BarModel barModelApr = BarModel(aprEarnings, 'Apr');
    BarModel barModelMay = BarModel(mayEarnings, 'May');
    BarModel barModelJun = BarModel(junEarnings, 'Jun');
    BarModel barModelJul = BarModel(julEarnings, 'Jul');
    BarModel barModelAug = BarModel(augEarnings, 'Aug');
    BarModel barModelSep = BarModel(sepEarnings, 'Sep');
    BarModel barModelOct = BarModel(octEarnings, 'Oct');
    BarModel barModelNov = BarModel(novEarnings, 'Nov');
    BarModel barModelDec = BarModel(decEarnings, 'Dec');
    data.add(barModelJan);
    data.add(barModelFeb);
    data.add(barModelMar);
    data.add(barModelApr);
    data.add(barModelMay);
    data.add(barModelJun);
    data.add(barModelJul);
    data.add(barModelAug);
    data.add(barModelSep);
    data.add(barModelOct);
    data.add(barModelNov);
    data.add(barModelDec);
    return data;
  }

  List<BarModel> getBarModelOfEachDayOfWeek(initialDate, finalDate, weekStats) {
    List<BarModel> data = [];
    int dayOneEarnings = 0,
        dayTwoEarnings = 0,
        dayThreeEarnings = 0,
        dayFourEarnings = 0,
        dayFiveEarnings = 0,
        daySixEarnings = 0,
        daySevenEarnings = 0;
    if(weekStats['day1'].length >= 1){
      dayOneEarnings = weekStats['day1'][0]['totalAmount'];
    }
    if(weekStats['day2'].length >= 1){
      dayTwoEarnings = weekStats['day2'][0]['totalAmount'];
    }
    if(weekStats['day3'].length >= 1){
      dayThreeEarnings = weekStats['day3'][0]['totalAmount'];
    }
    if(weekStats['day4'].length >= 1){
      dayFourEarnings = weekStats['day4'][0]['totalAmount'];
    }
    if(weekStats['day5'].length >= 1){
      dayFiveEarnings = weekStats['day5'][0]['totalAmount'];
    }
    if(weekStats['day6'].length >= 1){
      daySixEarnings = weekStats['day6'][0]['totalAmount'];
    }
    if(weekStats['day7'].length >= 1){
      daySevenEarnings = weekStats['day7'][0]['totalAmount'];
    }

    List<String> days = [];

    for(int i = 0 ; i <= 6 ; i++){
      days.add(DateFormat('d MMM').format(initialDate.add(Duration(days: i))));
    }
    BarModel dayOneEarningsBarModel = BarModel(dayOneEarnings, days[0]);
    BarModel dayTwoEarningsBarModel = BarModel(dayTwoEarnings, days[1]);
    BarModel dayThreeEarningsBarModel = BarModel(dayThreeEarnings, days[2]);
    BarModel dayFourEarningsBarModel = BarModel(dayFourEarnings, days[3]);
    BarModel dayFiveEarningsBarModel = BarModel(dayFiveEarnings, days[4]);
    BarModel daySixEarningsBarModel = BarModel(daySixEarnings, days[5]);
    BarModel daySevenEarningsBarModel = BarModel(daySevenEarnings, days[6]);
    data.add(dayOneEarningsBarModel);
    data.add(dayTwoEarningsBarModel);
    data.add(dayThreeEarningsBarModel);
    data.add(dayFourEarningsBarModel);
    data.add(dayFiveEarningsBarModel);
    data.add(daySixEarningsBarModel);
    data.add(daySevenEarningsBarModel);
    return data;
  }

  String getImageName(brandName, type, isChilled, isInPack){
    if(type == 'General'){
      return 'assets/Water Bottle/Normal/general_bottle.png';
    }
    String imageName = 'assets/$type/';

    if(isInPack){
      imageName = imageName + 'Pack of Bottles/';
    }
    else{
      if(isChilled)
         imageName = imageName + 'Chilled/';
      else
        imageName = imageName + 'Normal/';
    }
    switch(brandName){
      case 'Aquafina': imageName = imageName + 'aquafina.png';break;
      case 'Bailey': imageName = imageName + 'bailey.png';break;
      case 'Bisleri': imageName = imageName + 'bisleri.png';break;
      case 'Himalayan': imageName = imageName + 'himalayan.png';break;
      case 'Kinley': imageName = imageName + 'kinley.png';break;
      case 'Bonaqua': imageName = imageName + 'bonaqua.png';break;
      default: imageName = type == 'Water Bottle' ? imageName + 'general_bottle.png' : imageName = imageName + 'general_can';
    }
    return imageName;
  }

  String fetchItemQuantityInLiters(stringQtyInL, stringQtyInMl){
    String finalQty = '';
    int qtyInL = int.parse(stringQtyInL);
    int qtyInMl = int.parse(stringQtyInMl);
    if(qtyInL == 0){
      return stringQtyInMl + "ml";
    }
    if(qtyInMl == 0){
      return stringQtyInL + "L";
    }
    finalQty = (qtyInL + qtyInMl * 0.001).toString();
    return finalQty + 'L';
  }

  List<String> segregateGeneralItemQuantity(String qty){
    if(qty[qty.length - 1] == 'l'){
      return ['0', qty.substring(0, qty.length - 2)];
    }

    qty = qty.substring(0, qty.length - 1);
    double qtyInL = double.parse(qty);
    int qtyInMl = (qtyInL * 1000).floor();
    String litrePart = qtyInMl.toString().substring(0, qtyInMl.toString().length - 3);
    String miliLitrePart = int.parse(qtyInMl.toString().substring( qtyInMl.toString().length - 3)).toString();
    return [litrePart, miliLitrePart];
  }

  bool isValidSlotTime(String? slot1Start, String? slot2Start, String? slot1End, String? slot2End){
    if(slot2End == '') {
      if(slot1Start == slot1End){
        return false;
      }
      return true;
    }
    int slot1StartHour = int.parse(slot1Start!.split(':').first);
    int slot2StartHour = int.parse(slot2Start!.split(':').first);
    int slot1EndHour = int.parse(slot1End!.split(':').first);
    int slot2EndHour = int.parse(slot2End!.split(':').first);

    if(slot1StartHour >= slot1EndHour || slot2StartHour >= slot2EndHour){
      return false;
    }
    if(slot1StartHour == slot2StartHour && slot1EndHour == slot2EndHour){
      return false;
    }
    if(slot2StartHour < slot1EndHour){
      return false;
    }
    if(slot2EndHour < slot1StartHour){
      return false;
    }
    return true;
  }

  fetchItemQuantity(String itemQuantity){
    if(itemQuantity[itemQuantity.length - 1] == 'L'){
      return itemQuantity.substring(0, itemQuantity.length - 1);
    }
    return itemQuantity.substring(0, itemQuantity.length - 2);
  }

  fetchItemQuantityUnit(String itemQuantity){
    if(itemQuantity[itemQuantity.length - 1] == 'L'){
      return 'L';
    }
    return 'ml';
  }

}

