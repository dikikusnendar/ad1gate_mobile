import 'package:adira_finance/custom/upper_clipper.dart';
import 'package:adira_finance/main.dart';
import 'package:adira_finance/views/captcha.dart';
import 'package:adira_finance/views/dialog_term_and_condition.dart';
import 'package:adira_finance/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get_ip/get_ip.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show Random;

import 'custom/responsive_screen.dart';
import 'db_helper/database_helper.dart';
import 'resources/login_api_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _secureText = true;
  Screen size;
  var _uid,_pwd,_ipAddress;
  var _autoValidate = false;
  final _key = new GlobalKey<FormState>();
  final _tecUid =  TextEditingController();
  final _tecPassword = TextEditingController();
  final _randomText = TextEditingController();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _valueRrandomText = TextEditingController();
  LoginApiProvider _loginApiProvider;
  var _loginProcess = false;
  DbHelper _dbHelper = DbHelper();

  _showHidePass() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _loginApiProvider = LoginApiProvider();
    _getIpAddress();
    _setRandomText();
    _checkLoginDate();
  }

  _setRandomText(){
    setState(() {
      _randomText.text = randomAlphaNumeric(4);
    });
  }

  _getIpAddress() async{
    String ipAddress = await GetIp.ipAddress;
    setState(() {
      _ipAddress = ipAddress;
    });
  }

  _checkLoginDate() async{
    setState(() {
      _loginProcess = true;
    });
    var _result = await _dbHelper.getDateLogin();
    if(_result.length > 0){
      setState(() {
        _loginProcess = false;
      });
      _goToHome();
    }
    else{
      setState(() {
        _loginProcess = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _upperPart(),
              SizedBox(height: size.hp(7)),
              Form(
                key: _key,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.wp(8)),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _tecUid,
                        style: new TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontFamily: "NunitoSans", color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.red)
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (e) => _uid = e,
                        validator: _validateEmail,
                        autovalidate: _autoValidate,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _tecPassword,
                        style: new TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontFamily: "NunitoSans", color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.red)
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: _showHidePass),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText:_secureText,
                        onSaved: (e) => _pwd = e,
                        validator: (e){
                          if(e.isEmpty){
                            return "Can't be empty";
                          }
                          else{
                            return null;
                          }
                        },
                        autovalidate: _autoValidate,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                                onPressed: (){
                                  _setRandomText();
                                },
                                padding: EdgeInsets.only(top: size.hp(2.37),bottom: size.hp(2.37)),
                                child: Icon(Icons.refresh),
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0)))),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: _randomText,
                              style: new TextStyle(color: Colors.white,wordSpacing: 32,
                                  fontFamily: "NunitoSans",fontSize: 21,
                                  fontStyle: FontStyle.italic,letterSpacing: 6),
                              enabled: false,
                              decoration: new InputDecoration(
                                fillColor: Colors.grey,
                                filled: true,
                                contentPadding: EdgeInsets.only(top: size.hp(1.9),bottom: size.hp(1.9)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(0),
                                        topLeft: Radius.circular(0)
                                    ),
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: _valueRrandomText,
                              style: new TextStyle(color: Colors.white),
                              validator: (e){
                                if(e.isEmpty){
                                  return "Can't be empty";
                                }
                                else{
                                  return null;
                                }
                              },
                              autovalidate: _autoValidate,
                              decoration: new InputDecoration(
                                labelText: 'Input random text',
                                labelStyle: TextStyle(
                                    fontFamily: "NunitoSans", color: Colors.white),
                                  contentPadding: EdgeInsets.only(top: size.hp(1.9),bottom: size.hp(1.9),left: size.wp(2),right: size.wp(2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8)
                                    ),
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8)
                                    ),
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                        topLeft: Radius.circular(8)
                                    ),
                                    borderSide: BorderSide(color: Colors.red)
                                ),
                                  errorText: _errorRandomNotmatch ? "Random text not match" : null
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _loginProcess ? Center(child: CircularProgressIndicator()) :RaisedButton(
                        color: myPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Login",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "NunitoSansBold")),
                          ],
                        ),
                        padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                        onPressed: () {
//                          _testInsertLogin();
//                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
                         _check(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.hp(3)),
              InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute<DismissDialogTermAndCondition>(
                        builder: (BuildContext context) => DialogTermAndCondition(),
                        fullscreenDialog: true,
                      )
                  );
                },
                child: Container(
                  child: Text(
                      "Terms and Conditions",
                      style: TextStyle(
                          fontFamily: "NunitoSansSemiBold",
                          color: Colors.white,
                        decoration: TextDecoration.underline,
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _upperPart(){
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.hp(35),
            decoration: BoxDecoration(
              color: myPrimaryColor
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: size.hp(4)),
              child: Image.asset('img/logo_adira.png', height: 150, width: 150)),
        )
      ],
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }
    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }

  _check(BuildContext context){
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _validasiRandomText();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  var _errorRandomNotmatch = false;
  _validasiRandomText(){
    if(_valueRrandomText.text != _randomText.text){
      setState(() {
        _errorRandomNotmatch = true;
        _setRandomText();
      });
    }
    else{
      setState(() {
        _errorRandomNotmatch = false;
      });
      _login();
    }
  }

  _login() async{
    setState(() {
      _loginProcess = true;
    });
    var _result = await _loginApiProvider.loginProcess(_tecUid.text, _tecPassword.text, _ipAddress);
    if(_result['message'] == "Success"){
      DateTime _dateLogin = DateTime.now();
      var _dateLogout = DateTime(_dateLogin.year,_dateLogin.month,_dateLogin.day+7);
      DateFormat _formatted = DateFormat("yyyy-MM-dd");
      String _dateLoginText = _formatted.format(_dateLogin);
      String _dateLogoutText = _formatted.format(_dateLogout);
      _dbHelper.addDateLogin(_dateLoginText, _dateLogoutText);
      _savePref(_result['userDlc'], _tecUid.text);
      setState(() {
        _loginProcess = false;
      });
      _goToHome();
    }
    else{
      setState(() {
        _loginProcess = false;
      });
      _showSnackBar(_result['message']);
    }
  }
  _goToHome(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState
        .showSnackBar(
        SnackBar(content: new Text(text,style: TextStyle(
            fontFamily: "NunitoSans",color: Colors.black)),
          behavior: SnackBarBehavior.floating,backgroundColor: Colors.white,));
  }

  _savePref(String userDLC,String email) async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    setState(() {
      _preferences.setString("userDLC", userDLC);
      _preferences.setString("email", email);
    });
  }

//  _testInsertLogin() async{
//    DateTime _dateLogin = DateTime.now();
//    var _dateLogout = DateTime(_dateLogin.year,_dateLogin.month,_dateLogin.day+7);
//    DateFormat _formatted = DateFormat("yyyy-MM-dd");
//    String _dateLoginText = _formatted.format(_dateLogin);
//    String _dateLogoutText = _formatted.format(_dateLogout);
//    _dbHelper.addDateLogin(_dateLoginText, _dateLogoutText);
//    _goToHome();
//  }
}
