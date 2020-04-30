import 'dart:convert';

import 'package:adira_finance/constan/url.dart';
import 'package:http/http.dart' show Client;

class GetDataKecamatanApiProvider{
  Client _client = Client();
  Future<Map> getAllKecamatan(String kecamatan) async{
    try{
      final _response = await _client.get("${BaseUrl.url}Submit/GetKecamatan?search=$kecamatan");
      final _data = jsonDecode(_response.body);
      if(_response.statusCode == 200){
        var _listAllKecamatan = [];
        for(var i=0; i<_data['Data'].length; i++){
          _listAllKecamatan.add(_data['Data'][i]);
        }
        var _result = {"status":true,"listAllKecamatan":_listAllKecamatan};
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