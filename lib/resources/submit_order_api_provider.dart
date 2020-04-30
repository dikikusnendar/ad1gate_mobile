import 'dart:async';
import 'dart:convert';

import 'package:adira_finance/constan/url.dart';
import 'package:http/http.dart' show Client;


class SubmitOrderForm{
  Future<Map> submitOrder(var body) async{
    Client _client = Client();
    var _body = jsonEncode(body);
    try{
      final _response = await _client.post("${BaseUrl.url}Submit/SubmitOrderAd1gate", headers: {"Content-Type":"application/json"},
          body: _body
      );
      print("cek status${_response.statusCode}");
      if(_response.statusCode == 200){
        final _data = jsonDecode(_response.body);
        print(_data);
        var _result;
        if(_data['Status'] == 0){
          _result = {"status":true,"message":_data['Message'],"data":_data['Data']};
        }
        else{
          _result = {"status":false,"message":_data['Message']};
        }
        return _result;
      }
      else{
        var _result = {"status":false,"message":"Failed get data"};
        return _result;
      }
    }
//    on TimeoutException catch(_){
//      var _result = {"status":false,"message":"Connection Timeout"};
//      return _result;
//    }
    catch(e){
      print(e.toString());
      var _result = {"status":false,"message":e.toString()};
      return _result;
    }
  }
}