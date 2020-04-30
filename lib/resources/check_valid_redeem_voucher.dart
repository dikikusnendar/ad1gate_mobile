import 'dart:convert';

import 'package:adira_finance/constan/url.dart';
import 'package:http/http.dart' show Client;
class CheckValidRedeemVoucher{
  Client client = Client();
  Future<Map> checkRedeemVoucher(String noKTP,String NoVoucher) async{
    try{
      final _response = await client.post("${BaseUrl.url}Submit/CheckRedeemVoucher",body: {
        "noKTP": noKTP,
        "NoVoucher":NoVoucher
      });
      final _data = jsonDecode(_response.body);
      if(_response.statusCode == 200){
        var _result = {"status":true, "IsValid": _data['Data'][0]['IsValid'],"remark": _data['Data'][0]['remark']};
        return _result;
      }
      else{
        var _result = {"status":false,"message": _data['Message']};
        return _result;
      }
    }
    catch(e){
      print(e.toString());
      var _result = {"status":false,"message": e.toString()};
      return _result;
    }
  }
}