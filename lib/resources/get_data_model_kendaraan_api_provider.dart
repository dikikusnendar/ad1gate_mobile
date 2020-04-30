import 'dart:convert';

import 'package:adira_finance/constan/url.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class GetDataModelKendaraanApiProvider{
  Client _client = Client();
  Future<Map> getModelKendaraan(String model,String idStatusKendaraan) async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var dlc =  _preferences.getString("userDLC");
    try{
      final _response = await _client.post(
        "${BaseUrl.url}Submit/GetModel",
        body: {
          "search": model,
          "branchid": "0321",
          "groupcode": idStatusKendaraan,
          "dlc": dlc
        }
      );
      final _data = jsonDecode(_response.body);
      if(_response.statusCode == 200){
        var _listModelKendaraan = [];
        for(var i=0; i<_data['Data'].length; i++){
          _listModelKendaraan.add(_data['Data'][i]);
        }
        var _result = {"status":true,"listModelKendaraan":_listModelKendaraan};
        print(_result);
        return _result;
      }
      else{
        var _result = {"status": false,"message":_data['Data']['Message']};
        return _result;
      }
    }
    catch(e){
      var _result = {"status": false,"message":e.toString()};
      return _result;
    }
  }
}