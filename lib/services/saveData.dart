import 'package:waterdrop_supplier/helper/helper.dart';

class SaveData{
  storeUserDataInLocalStorage(result) async {
    await HelperFunctions.savePhoneNumberSharedPreference(int.parse(result['locationData']['phone']));
    await HelperFunctions.saveUserTokenSharedPreference(result['token']);
    await HelperFunctions.saveLocationIdSharedPreference(result['locationData']['_id']);
    if(result['locationData']['email']!=null) {
      await HelperFunctions.saveUserMailIdSharedPreference(
          result['locationData']['email']);
    }
    else{
      await HelperFunctions.saveUserMailIdSharedPreference(
          '');
    }
    await HelperFunctions.saveStoreNameSharedPreference(result['locationData']['name']);
  //  await HelperFunctions.saveUserNameSharedPreference(result['locationData']['ownerName']);
    await HelperFunctions.saveUserCodeSharedPreference(result['locationData']['locationCode']);
    await HelperFunctions.saveUserQrCodeLinkSharedPreference(result['locationData']['qrCodeLink']);
    String address = fetchSupplierAddressFromMap(result['locationData']['address']);
    await HelperFunctions.saveUserAddressSharedPreference(address);
    String shortAddress = fetchShortAddressFromMap(result['locationData']['address']);
    await HelperFunctions.saveUserShortAddressSharedPreference(shortAddress);
    await HelperFunctions.saveSupplierIdSharedPreference(result['locationData']['supplierId']);
    await HelperFunctions.saveUserSlot1StartTimeSharedPreference(result['locationData']['slot1Start']);
    await HelperFunctions.saveUserSlot1EndTimeSharedPreference(result['locationData']['slot1End']);
    if(result['locationData']['slot2Start'] != null) {
      await HelperFunctions.saveUserSlot2StartTimeSharedPreference(
          result['locationData']['slot2Start']);
    }
    else{
      HelperFunctions.saveUserSlot2StartTimeSharedPreference(
          '');
    }
    if(result['locationData']['slot2End'] != null) {
      await HelperFunctions.saveUserSlot2EndTimeSharedPreference(
          result['locationData']['slot2End']);
    }
    else{
      HelperFunctions.saveUserSlot2EndTimeSharedPreference(
          '');
    }
    if(result['locationData']['aadhar'] != null) {
      await HelperFunctions.saveUserAadharCardSharedPreference(
          result['locationData']['aadhar']);
    }
    else{
      await HelperFunctions.saveUserAadharCardSharedPreference('');
    }
    await HelperFunctions.saveUserPanCardSharedPreference(result['locationData']['panNumber']);
    if(result['locationData']['gstinNumber'] != null) {
      await HelperFunctions.saveUserGSTNumberSharedPreference(
          result['locationData']['gstinNumber']);
    }
    else{
      await HelperFunctions.saveUserGSTNumberSharedPreference('');
    }

    if(result['locationData']['securityDepositAmount'] != null) {
      await HelperFunctions.saveUserSecurityDepositAmountSharedPreference(
          result['locationData']['securityDepositAmount'].toString());
    }
    else{
      await HelperFunctions.saveUserSecurityDepositAmountSharedPreference('');
    }

    if(result['locationData']['fastDeliveryCharges'] != null) {
      await HelperFunctions.saveUserFastDeliveryChargeSharedPreference(
          result['locationData']['fastDeliveryCharges'].toString());
    }
    else{
      await HelperFunctions.saveUserFastDeliveryChargeSharedPreference('');
    }
  }

  fetchAddressFromMap(addressMap){
    String street = addressMap['street'] ?? '';
    if(addressMap['landmark'] == null || addressMap['landmark'] == ''){
      String address = addressMap['houseNumber'] + ", " + "Floor No. " + addressMap['floor'].toString() + ', ' + street
          + ', ' + addressMap['city'] + ', ' + addressMap['state'] + ' - ' +
          addressMap['pincode'].toString();
      return address;
    }
    String address = addressMap['houseNumber'] + ", " + "Floor No. " + addressMap['floor'].toString() + ', ' + street
                      + ', ' + 'Near ' + addressMap['landmark'] + ', ' + addressMap['city'] + ', ' + addressMap['state'] + ' - ' +
                       addressMap['pincode'].toString();
    return address;
  }

  fetchSupplierAddressFromMap(addressMap){
    String street = addressMap['street'] ?? '';
    if(addressMap['landmanrk'] == null || addressMap['landmark'] == ''){
      String address = addressMap['officeNumber'].toString() + ', ' + street
          + ', ' + addressMap['city'] + ', ' + addressMap['state'] + ' - ' +
          addressMap['pincode'].toString();
      return address;
    }
    String address = addressMap['officeNumber'].toString() + ', ' + street
        + ', ' + 'Near ' + addressMap['landmark'] + ', ' + addressMap['city'] + ', ' + addressMap['state'] + ' - ' +
        addressMap['pincode'].toString();
    return address;
  }

  fetchCustomerAddressFromMap(addressMap){
    String street = addressMap['street'] ?? '';
    String address = "Floor no. " + addressMap['floor'].toString() + ', ' + addressMap['houseNumber'].toString() + ', ' + street +
        ', ' + addressMap['city'] + ', ' + addressMap['state'] + ' - ' +
        addressMap['pincode'].toString();
    return address;
  }

  fetchShortAddressFromMap(addressMap){
    String address = addressMap['street'] + ', ' + addressMap['city'] + ' - ' +
        addressMap['pincode'].toString();
    return address;
  }

}