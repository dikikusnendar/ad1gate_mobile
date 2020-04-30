import 'dart:convert';
import 'dart:io';

import 'package:adira_finance/constan/url.dart';
import 'package:http/http.dart' show Client;
class LoginApiProvider{
  Client client = Client();
  Future<Map> loginProcess(String uid,String pwd,String ipAddress) async{
    print("uid $uid");
    print("pwd $pwd");
    print("ipAddress $ipAddress");
    try{
      final _response = await client.post("${BaseUrl.url}login/authenticate",body: {
        "uid": uid,
        "pwd":pwd,
        "ipAddress": ipAddress
      });
      final _data = jsonDecode(_response.body);
      if(_data['Data'] != null){
        print(_data['Message']);
        var _result = {"message": _data['Message'],"userDlc": _data['Data']['UserDetail'][0]['UserDLC']};
        return _result;
      }
      else{
        var _result = {"message": _data['Message']};
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