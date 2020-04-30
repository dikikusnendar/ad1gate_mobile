import 'dart:async';
import 'dart:convert';
import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/resources/login_api_provider.dart';
import 'package:adira_finance/views/home.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class CaptchaPage extends StatefulWidget {
  final String uid,pwd,ipAddress;
  const CaptchaPage({Key key, this.uid, this.pwd, this.ipAddress}) : super(key: key);
  @override
  _CaptchaPageState createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> {
  Screen size;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String urlList = "https://adira.genesysindonesia.co.id/";

  LoginApiProvider _loginApiProvider;

  @override
  void initState() {
    super.initState();
    _loginApiProvider = LoginApiProvider();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Text(
            "Verification",
            style: TextStyle(
                fontFamily: "NunitoSans",color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        leading:
        IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black),
            onPressed: ()
            {
              Navigator.pop(context);
            }
        ),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: size.hp(4),left: size.wp(2)),
//        _height > 650
//            ?
//        EdgeInsets.only(top: size.hp(39),left: size.wp(11))
//            :
//        EdgeInsets.only(top: size.hp(33),left: size.wp(5.7)),
        child:
        SafeArea(
          child: WebView(
            initialUrl: "$urlList?api_key=6LcJkNUUAAAAACK1Ecomyvg7Uz3FhPisi4cpOf_S",
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[
              JavascriptChannel(
                name: 'RecaptchaFlutterChannel',
                onMessageReceived: (JavascriptMessage receiver) {
                  String _token = receiver.message;
                  print(_token);
                  if (_token.contains("verify")) {
                    _token = _token.substring(7);
                  }
                  print(_token);
                  verifyToken(_token);
                },
              ),
            ].toSet(),
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
      ),
    );
  }
  void verifyToken(String token) async {
    String url = "https://www.google.com/recaptcha/api/siteverify";
    final response = await http.post(url, body: {
      "secret": "6LcJkNUUAAAAALW5NbDqTrgALSYwAkbOs01mHgWb",
      "response": token,
    });
    final data = jsonDecode(response.body);
    if(data['success']){
      _login();
    }
  }

  _login() async{
    _showDialog();
    var _result = await _loginApiProvider.loginProcess(widget.uid, widget.pwd, widget.ipAddress);
    print(_result['message']);
    if(_result['message'] == "Success"){
      Navigator.pop(context);
      _goToHome(_result['userDlc']);
    }
    else{
      Navigator.pop(context);
      _backToLogin(_result['Message']);
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 6),
              Text("Login Process",style: TextStyle(fontFamily: "NunitoSans"))
            ],
          ),
        );
      },
    );
  }

  _goToHome(String userDLC){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  _backToLogin(String message){
    Navigator.pop(context,message);
  }
}
