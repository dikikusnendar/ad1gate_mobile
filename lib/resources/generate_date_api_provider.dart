import 'dart:convert';

import 'package:adira_finance/constan/url.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class GenerateDateApiProvider{
  Future<Map> generateDatesByAutoAssign(String zipCode,String kelurahan,String jenisKredit) async{
    Client _client = Client();
    try{
      final _response = await _client.post("${BaseUrl.url}Submit/GenerateDatesByAutoAssign",
          body: {
            "ZipCode":zipCode,
            "Kelurahan":kelurahan,
            "JenisKredit":jenisKredit
          }
      );
      print("cek status code ${_response.statusCode}");
      var _listDateByAutoAsign = [];
      if(_response.statusCode == 200){
        final _data = jsonDecode(_response.body);
        for(var i=0; i< _data['Data'].length; i++){
          _listDateByAutoAsign.add(_data['Data'][i]);
        }
        var _result = {"status":true,"listDateByAutoAsign":_listDateByAutoAsign};
        return _result;
      }
      else{
        var _result = {"status":false,"message":"Failed get data"};
        return _result;
      }
    }
    catch(e){
      var _result = {"status":false,"message":e.toString()};
      return _result;
    }
  }

  Future<Map> generateDatesByPemilihanCabang(String zipCode,String kelurahan,String jenisKredit) async{
    Client _client = Client();
    try{
      final _response = await _client.post(
          "${BaseUrl.url}Submit/GenerateDatesByAutoBranch",
          body: {
            "ZipCode":zipCode,
            "Kelurahan":kelurahan,
            "JenisKredit":jenisKredit
          },
      );
      if(_response.statusCode == 200){
        final _data = jsonDecode(_response.body);
        var _listGenerateDateByBranch = [];
        for(var i=0; i<_data["Data"].length;i++){
          _listGenerateDateByBranch.add(_data["Data"][i]);
        }
        var _result = {"status":true,"listGenerateDateByBranch":_listGenerateDateByBranch};
        print("cek result $_result");
        return _result;
      }
      else{
        final _data = jsonDecode(_response.body);
        var _result = {"status":true,"message":_data["Message"]};
        return _result;
      }
    }
    catch(e){
      var _result = {"status":true,"message":e.toString()};
      return _result;
    }
  }

  Future<Map> generateDatesByDadicateCMO(String zipCode,String kelurahan,String jenisKredit) async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var DLCCode = _preferences.getString("userDLC");
    Client _client = Client();
    var _body = jsonEncode({
      "DLCCode":DLCCode,
      "ZipCode":zipCode,
      "Kelurahan":kelurahan,
      "JenisKredit":jenisKredit
    });
    try{
      print(_body);
      final _response = await _client.post(
          "${BaseUrl.url}Submit/GenerateDatesByDedicateCMO",
          headers: {"Content-Type":"application/json"},
          body: _body
      );
      print("cek mkt extend response status ${_response.statusCode}");
      var _listDateByDedicateCMO = [];
      if(_response.statusCode == 200){
        final _data = jsonDecode(_response.body);
        print(_data);
        for(var i=0; i< _data['Data'].length; i++){
          _listDateByDedicateCMO.add(_data['Data'][i]);
          print(_listDateByDedicateCMO[i]);
        }
        var _result = {"status":true,"listDateByDedicateCMO":_listDateByDedicateCMO};
        return _result;
      }
      else{
        var _result = {"status":false,"message":"Failed get data"};
        return _result;
      }
    }
    catch(e){
      var _result = {"status":false,"message":"Failed get data"};
      return _result;
    }
  }

  Future<Map> generateDatesByAsIs(String zipCode,String kelurahan,String jenisKredit) async{
    Client _client = Client();
    try{
      final _response = await _client.post(
        "${BaseUrl.url}Submit/GenerateDatesByAsIs",
        body: {
          "ZipCode":zipCode,
          "Kelurahan":kelurahan,
          "JenisKredit":jenisKredit
        },
      );
      if(_response.statusCode == 200){
        final _data = jsonDecode(_response.body);
        var _listGenerateDatesByAsIs = [];
        for(var i=0; i<_data["Data"].length;i++){
          _listGenerateDatesByAsIs.add(_data["Data"][i]);
        }
        var _result = {"status":true,"listGenerateDatesByAsIs":_listGenerateDatesByAsIs};
        print(_result);
        return _result;
      }
      else{
        final _data = jsonDecode(_response.body);
        var _result = {"status":true,"message":_data["Message"]};
        return _result;
      }
    }
    catch(e){
      var _result = {"status":true,"message":e.toString()};
      return _result;
    }
  }
}