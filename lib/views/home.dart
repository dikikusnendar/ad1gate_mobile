import 'dart:io';

import 'package:adira_finance/constan/constan.dart';
import 'package:adira_finance/custom/responsive_screen.dart';
import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/login.dart';
import 'package:adira_finance/main.dart';
import 'package:adira_finance/views/form_transaksional_page.dart';
import 'package:adira_finance/views/submit_page.dart';
import 'package:adira_finance/views/draft_page.dart';
import 'package:adira_finance/views/tracking_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'dialog_redeem_voucher.dart';
import 'map_location.dart';


Color yellow = const Color(0xffdab600);

//class DrawerItem {
//  String title;
//  IconData icon;
//  DrawerItem(this.title, this.icon);
//}

class HomePage extends StatefulWidget {
  final int dif;

  const HomePage({Key key, this.dif}) : super(key: key);

//  final drawerItems = [
//    DrawerItem("Submit Order",Icons.home),
//    DrawerItem("Tracking Order",Icons.local_shipping),
//    DrawerItem("Draft",Icons.insert_drive_file),
//    DrawerItem("Signout",Icons.exit_to_app)
//  ];
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Screen size;
  DbHelper _dbHelper = DbHelper();
  var _checkSession = false;
//  int _selectedDrawerIndex = 0;

//  _getDrawerItemWidget(int pos) {
//    switch (pos) {
//      case 0:
//        return BerandaPage();
//      case 1:
//        return TrackingOrder(title: "Tracking Order",onMapTap: setDrawerIndex);
//      case 2:
//        return DraftPage("Draft",setDrawerIndex);
//      default:
//        return Text("Error");
//    }
//  }

//  _onSelectItem(int index) {
//    if(index == 3){
//      print("SignOut");
//    }else{
//      setState(() => _selectedDrawerIndex = index);
//      Navigator.of(context).pop(); // close the drawer
//    }
//  }
  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
//    List<Widget> drawerOptions = [];
//    for (var i = 0; i < widget.drawerItems.length; i++) {
//      var d = widget.drawerItems[i];
//      drawerOptions.add(
//          ListTileTheme(
//            selectedColor: yellow,
//            child: ListTile(
//              leading: new Icon(d.icon),
//              title: new Text(d.title,style: TextStyle(fontFamily: "NunitoSansBold")),
//              selected: i == _selectedDrawerIndex,
//              onTap: () => _onSelectItem(i),
//            ),
//          )
//      );
//    }
    return Scaffold(
      appBar:
//      _selectedDrawerIndex == 0
//          ?
      AppBar(
        backgroundColor: myPrimaryColor,
        title:
//        _selectedDrawerIndex == 0
//            ?
        Image.asset('img/logo_adira.png',scale: 2),
//            :
//        Text(widget.drawerItems[_selectedDrawerIndex].title,style: TextStyle(color: Colors.black,fontFamily: "NunitoSans")),
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: size.wp(2)),
            child: PopupMenuButton<String>(
                onSelected: (String value) {
                 _logout();
                },
                child: Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return Constant.choices.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
          )
        ],
      ),
//          :
//      null,
//      drawer: Drawer(
//        child: Container(
//          color: Colors.white,
//          child: Column(
//            children: <Widget>[
//              UserAccountsDrawerHeader(
//                  decoration: BoxDecoration(color: Colors.white),
//                  currentAccountPicture: CircleAvatar(
//                    backgroundImage: AssetImage('img/profile.webp'),
//                    backgroundColor: Colors.transparent,
//                  ),
//                  accountName: Text("User Adira",style: TextStyle(color: Colors.black,fontSize: 18)),
//                  accountEmail: Text("user@adirafinance.com",style: TextStyle(color: Colors.black))
//              ),
//              Column(children: drawerOptions)
//            ],
//          ),
//        ),
//      ),
      body:
      _checkSession
          ?
      Center(child: CircularProgressIndicator())
          :
      ListView(
        padding: EdgeInsets.only(top: 16,bottom: 16,left: 8,right: 8),
        children: <Widget>[
          InkWell(
            onTap: (){
              _checkSessionFromSubmitOrderButton();
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(top: 8,bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                            child: Image.asset("img/submit_order.webp",height: 97,width: 117)
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text("Submit Order",style: TextStyle(fontFamily: "NunitoSansSemiBold",fontSize: 24)))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: (){
             _checkSessionFromTrackingButton();
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(top: 8,bottom: 8),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                            child: Image.asset("img/tracking_order.webp",height: 97,width: 117)),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text("Tracking Order",style: TextStyle(fontFamily: "NunitoSansSemiBold",fontSize: 24)))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          InkWell(
            onTap: (){
              _checkSessionFromDraftButton();
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(top: 8,bottom: 8),
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),topLeft: Radius.circular(8)),
                            child: Image.asset("img/draft.webp",height: 97,width: 117)),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Text("Draft",style: TextStyle(fontFamily: "NunitoSansSemiBold",fontSize: 24)))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
//        _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  _checkSessionFromSubmitOrderButton() async{
    setState(() {
      _checkSession = true;
    });
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var _dateNow = DateTime.now();
    DateFormat _formatter = DateFormat("yyyy-MM-dd");
    String _dateNowText = _formatter.format(_dateNow);
    DateTime _dateNowFinal = DateTime.parse(_dateNowText);
    var _result = await _dbHelper.getDateLogin();
    var _dateLogout = _result[0]['logout_date'];
    var _dateLogoutFinal = DateTime.parse(_dateLogout);
    Duration _difference = _dateNowFinal.difference(_dateLogoutFinal);
    if(_difference.inDays == 0){
      _dbHelper.deleteDateLogin();
      _preferences.clear();
      setState(() {
        _checkSession = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return LoginPage();
          }, transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),(Route route) => false);
    }
    else{
      setState(() {
        _checkSession = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FormTransaksionalPage()));
    }
  }

  _checkSessionFromTrackingButton() async{
    setState(() {
      _checkSession = true;
    });
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var _dateNow = DateTime.now();
    DateFormat _formatter = DateFormat("yyyy-MM-dd");
    String _dateNowText = _formatter.format(_dateNow);
    DateTime _dateNowFinal = DateTime.parse(_dateNowText);
    var _result = await _dbHelper.getDateLogin();
    var _dateLogout = _result[0]['logout_date'];
    var _dateLogoutFinal = DateTime.parse(_dateLogout);
    Duration _difference = _dateNowFinal.difference(_dateLogoutFinal);
    if(_difference.inDays == 0){
      _dbHelper.deleteDateLogin();
      _preferences.clear();
      setState(() {
        _checkSession = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return LoginPage();
          }, transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),(Route route) => false);
    }
    else{
      setState(() {
        _checkSession = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TrackingOrder()));
    }
  }

  _checkSessionFromDraftButton() async{
    setState(() {
      _checkSession = true;
    });
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var _dateNow = DateTime.now();
    DateFormat _formatter = DateFormat("yyyy-MM-dd");
    String _dateNowText = _formatter.format(_dateNow);
    DateTime _dateNowFinal = DateTime.parse(_dateNowText);
    var _result = await _dbHelper.getDateLogin();
    var _dateLogout = _result[0]['logout_date'];
    var _dateLogoutFinal = DateTime.parse(_dateLogout);
    Duration _difference = _dateNowFinal.difference(_dateLogoutFinal);
    if(_difference.inDays == 0){
      _dbHelper.deleteDateLogin();
      _preferences.clear();
      setState(() {
        _checkSession = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return LoginPage();
          }, transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }),(Route route) => false);
    }
    else{
      setState(() {
        _checkSession = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DraftPage()));
    }
  }

  _logout() async{
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _dbHelper.deleteDateLogin();
    _preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return LoginPage();
        }, transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),(Route route) => false);
  }

  @override
  void initState() {
    super.initState();
    if(widget.dif != null){
      _checkSessionFromTrackingButton();
    }
  }

//  setDrawerIndex(){
//    setState(() {
//      _selectedDrawerIndex = 0;
//    });
//  }
}
