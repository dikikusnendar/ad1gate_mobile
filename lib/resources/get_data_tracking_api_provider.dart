import 'dart:convert';

import 'package:adira_finance/constan/url.dart';
import 'package:adira_finance/model/submit_order_model.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class GetDataTrackingApiProvider{
  Client _client = Client();
  Future<Map> getBranchByDLC() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String _userDLC = _preferences.getString("userDLC");
    try{
      final _response = await _client.get("${BaseUrl.url}Tracking/GetBranchByDLC?dlc=$_userDLC");
      final _data = jsonDecode(_response.body);
      print(_data.toString());
      if(_data['Status'] == 0){
        if(_data['Data'].length > 1){
          var _listBranch = [];
          for(int i=0; i<_data["Data"].length; i++){
            _listBranch.add(_data['Data'][i]);
          }
          var _result = {"status": true, "listBranch":_listBranch};
          print("cek result $_result");
          return _result;
        }
        else{
          print("data kosong ${_data['Data'].length}");
          var _result = {"status":false, "message":"0"};
          return _result;
        }
      }
      else{
        var _result = {"status": false, "message":_data['Message']};
        return _result;
      }
    }
    catch(e){
      var _result = {"status": false,"message":e.toString()};
      return _result;
    }
  }

  Future<Map> getStatusOrder(String idTracking) async{
    Client _client = Client();
    try{
      final _response = await _client.get("${BaseUrl.url}Tracking/GetStatusOrder?track=$idTracking");
      final _data = jsonDecode(_response.body);
      print(_data);
      if(_data['Data'].length < 1){
        var _result = {"status": false,"message":"Tracking Id not found"};
        return _result;
      }
      else{
        print("Cek isi ${_data['Data'].length}");
        var _listStatusOrder = [];
        for(var i=0; i<_data['Data'].length; i++){
          _listStatusOrder.add(_data["Data"][i]);
        }
        var _result = {"status": true,"listStatusOrder":_listStatusOrder};
        return _result;
      }
    }
    catch(e){
      var _result = {"status": false,"message":e.toString()};
      return _result;
    }
  }

  Future<Map> getTrackingByStatusOrderAll(String statusOrder,String branchId,String startDate,String endDate,String idTracking) async{
    Client _client = Client();
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String _userDLC = _preferences.getString("userDLC");
    var _body = jsonEncode({
      "SZSEARCH": "",
      "SZFROW": "1",
      "SZLROW": "25",
      "SZSTRORDER": "",
      "SZSTATUS": statusOrder,
      "SZBRANCHID": branchId,
      "SZDEALER": _userDLC,
      "SZORDERDATE_START1": startDate,
      "SZORDERDATE_END1": endDate,
      "SZTRACKINGDATE": idTracking
    });
    print("cek body $_body");
    try{
      final _response = await _client.post(
        "${BaseUrl.url}Tracking/GetTrackingCount",
        body: {
          "SZSEARCH": "",
          "SZFROW": "1",
          "SZLROW": "25",
          "SZSTRORDER": "",
          "SZSTATUS": statusOrder,
          "SZBRANCHID": branchId,
          "SZDEALER": _userDLC,
          "SZORDERDATE_START1": startDate,
          "SZORDERDATE_END1": endDate,
          "SZTRACKINGDATE": idTracking
        },
      );
      final _data = jsonDecode(_response.body);
      print(_data);
      print(_response.statusCode);
      if(_response.statusCode == 200){
        var _listDataTrackingCount = [];
        for(var i=0; i<_data['Data']['SZRECORDS'].length;i++){
          _listDataTrackingCount.add(_data['Data']['SZRECORDS'][i]);
        }
        var _result = {"status":true,"listDataTrackingCount":_listDataTrackingCount};
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

  Future<Map> getTrackingByExceptStatusOrderAll(String statusOrder,String branchId,String startDate,String endDate,String idTracking) async{
    Client _client = Client();
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String _userDLC = _preferences.getString("userDLC");

    var _checkBody = {
      "SZSEARCH": "",
      "SZFROW": "1",
      "SZLROW": "2000",
      "SZSTRORDER": "7 desc",
      "SZSTATUS": statusOrder,
      "SZBRANCHID": branchId,
      "SZDEALER": _userDLC,
      "SZORDERDATE_START1": startDate,
      "SZORDERDATE_END1": endDate,
      "SZTRACKINGDATE": idTracking
    };
    print("check body $_checkBody");

    try{
      final _response = await _client.post(
          "${BaseUrl.url}Tracking/GetSummaryTracking",
          body: {
            "SZSEARCH": "",//"ANDROID",
            "SZFROW": "1",
            "SZLROW": "2000",
            "SZSTRORDER": "7 desc",
            "SZSTATUS": statusOrder,
            "SZBRANCHID": branchId,
            "SZDEALER":  _userDLC,
            "SZORDERDATE_START1": startDate,
            "SZORDERDATE_END1": endDate,
            "SZTRACKINGDATE": idTracking
          }
      );
      final _data = jsonDecode(_response.body);
      print(_data);
      if(_response.statusCode == 200){
        var _listDataTrackingCount = [];
        for(var i=0; i<_data['Data']['SZRECORDS'].length;i++){
          _listDataTrackingCount.add(_data['Data']['SZRECORDS'][i]);
        }
        var _result = {"status":true,"listDataTrackingByCategory":_listDataTrackingCount};
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

  Future<Map> getDetailTrackingOrder(String branchId, String numberApplication) async{
    Client _client = Client();
    try{
      final _response = await _client.get("${BaseUrl.url}Tracking/GetDetailOrder?brid=$branchId&applno=$numberApplication");
      print(_response.statusCode);
      var _result;
      if(_response.statusCode == 200){
        final _data = jsonDecode(_response.body);
        print("cek dataku $_data");
        if(_data['Status'] == 0){
          var _dataDetailTrackingOrder = _data['Data'][0];
          _result = {"status":true,"message":_data['Message'],"dataDetailTrackingOrder":_dataDetailTrackingOrder};
        }
        else if(_data['Status'] == 1){
          _result = {"status":false,"message":_data['Message'],"dataDetailTrackingOrder":""};
        }
        else{
          _result = {"status":false,"message":_data['Message'],"dataDetailTrackingOrder":""};
        }
        return _result;
      }
    }
    catch(e){
      print(e.toString());
      var _result = {"status":false,"message":e.toString(),"dataDetailTrackingOrder":""};
      return _result;
    }
  }

  Future<SubmitOrderModel> getAllListDataSubmitOrder() async{
    Client _client = Client();
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String _userDLC = _preferences.getString("userDLC");
    String _userID = _preferences.getString("email");
    final _response = await _client.post("${BaseUrl.url}/Submit/GetListSubmitOrder",
        body: {"UserID": _userID,"CodeDLC":_userDLC,"Search":""});
    final _data = jsonDecode(_response.body);
    List _dataSubmitOrder = [];
    for(var i=0; i < _data['Data'].length; i++){
      _dataSubmitOrder.add(_data['Data'][i]);
      print("cek remark ${_data['Data'][i]['Remark']}");
      print("cek status ${_data['Data'][i]['Status']}");
      print("cek type kendaraan ${_data['Data'][i]['Type_kendaraan']}");
    }
    return SubmitOrderModel.fromJson(_dataSubmitOrder);
  }

  Future<SubmitOrderModel> getListDataSubmitOrderBySearch(String query) async{
    Client _client = Client();
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String _userDLC = _preferences.getString("userDLC");
    String _userID = _preferences.getString("email");
    final _response = await _client.post("${BaseUrl.url}/Submit/GetListSubmitOrder",
        body: {"UserID": _userID,"CodeDLC":_userDLC,"Search":query});
    final _data = jsonDecode(_response.body);
    List _dataSubmitOrder = [];
    for(var i=0; i < _data['Data'].length; i++){
      _dataSubmitOrder.add(_data['Data'][i]);
    }
    return SubmitOrderModel.fromJson(_dataSubmitOrder);
  }
}