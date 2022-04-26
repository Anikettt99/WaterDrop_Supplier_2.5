import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class LocationService{
  final String key = "AIzaSyDLSHrktWbNRHbbtx12j9ETRPuWe2vwGnI";

  Future<String> getPlaceId(String input) async {
    String url ="https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${input}&inputtype=textquery&key=$key";
    var response = await http.get(Uri.parse(url));
    print(response.body);
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String ;
    print(placeId);
    return placeId;
  }


  /*Future<Map<String, dynamic>> getPlace(String input) async{

  }*/
}