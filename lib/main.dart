import 'dart:async';
import 'dart:io';

import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/views/first_widget_stepper.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as handler;
import 'package:sqflite/sqflite.dart';

import 'login.dart';
import 'views/search_delegate_dealer_cabang.dart';
import 'views/search_delegate_kecamatan.dart';

Color myPrimaryColor = const Color(0xffFEDE00);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adira Finance',
      localizationsDelegates: [
        CustomLocalizationDelegate()
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
//        accentColor: Colors.black,
      ),
      home: MyHomePage(title: 'Adira Finance'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Location _locationService  = new Location();
  bool _permission = false;
  String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myPrimaryColor,
      body: Center(
        child: Image.asset('img/logo_adira.png'),
      ),
    );
  }

  DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    initDatabase();
    checkPermissionLocation();
  }

  initDatabase() async{
    _dbHelper.initDatabase();
  }

//  void initPlatformState() async {
//    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);
//
//    LocationData location;
//
//    try{
//      bool serviceStatus = await _locationService.serviceEnabled();
//      print("Service status: $serviceStatus");
//      if (serviceStatus) {
//        _permission = await _locationService.requestPermission();
//        print("Permission: $_permission");
//        if (_permission) {
//          location = await _locationService.getLocation();
//          print(location.latitude.toString());
////          checkPermission();
//        }else if(!_permission){
//          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//        }
//      } else {
//        bool serviceStatusResult = await _locationService.requestService();
//        print("Service status activated after request: $serviceStatusResult");
//        if(serviceStatusResult){
//          _permission = await _locationService.requestPermission();
//          print("Permission: $_permission");
//          if (_permission) {
//            location = await _locationService.getLocation();
//            print(location.latitude.toString());
////            checkPermission();
//          }else if(!_permission){
//            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//          }
////          initPlatformState();
//        }
//        else{
//          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//        }
//      }
//    }on PlatformException catch (e) {
//      print("cek status : $e");
//      if (e.code == 'PERMISSION_DENIED') {
//        error = e.message;
//      } else if (e.code == 'SERVICE_STATUS_ERROR') {
//        error = e.message;
//      }
//      location = null;
//    }
//  }


  Directory externalDir;
  var path = "No Data";
  String dirLoc = "";
  handler.PermissionStatus permissionStatusStorage;
  handler.PermissionStatus permissionStatusLocation;


  checkPermissionLocation() async{
    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);

    bool serviceStatus = await _locationService.serviceEnabled();

    if(serviceStatus){
      print("serviceStatus $serviceStatus");
      permissionStatusLocation = await handler.PermissionHandler().checkPermissionStatus(handler.PermissionGroup.location);
      if(permissionStatusLocation == handler.PermissionStatus.denied){
        Map<handler.PermissionGroup, handler.PermissionStatus> permissions =
        await handler.PermissionHandler().requestPermissions([handler.PermissionGroup.location]);
        print("cek mypermissions ${permissions['PermissionGroup.location']}");
        checkPermissionStorage();
      }
      else{
        print("serviceStatus else");
        checkPermissionStorage();
      }
    }
    else{
      bool serviceStatusResult = await _locationService.requestService();
      if(serviceStatusResult){
        print("serviceStatusResult $serviceStatusResult");
        permissionStatusLocation = await handler.PermissionHandler().checkPermissionStatus(handler.PermissionGroup.location);
        if(permissionStatusLocation == handler.PermissionStatus.denied){
          var permissions = await handler.PermissionHandler().requestPermissions([handler.PermissionGroup.location]);
          print("cek mypermissions $permissions");
          checkPermissionStorage();
        }
      }
      else{
        print("serviceStatusResult else");
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
  }

  checkPermissionStorage() async{
    permissionStatusStorage = await handler.PermissionHandler().checkPermissionStatus(handler.PermissionGroup.storage);
    print(permissionStatusStorage);
    if(permissionStatusStorage == handler.PermissionStatus.denied){
      Map<handler.PermissionGroup, handler.PermissionStatus> permissions =
      await handler.PermissionHandler().requestPermissions([handler.PermissionGroup.storage]);
      print(permissions.toString());

      if(Platform.isAndroid){
        dirLoc = "/sdcard/Adira PDF";
        try{
          FileUtils.mkdir([dirLoc]);
          Timer(Duration(seconds: 2), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        }
        catch(e){
          print(e.toString());
        }
      }
      else{
        dirLoc = (await getApplicationDocumentsDirectory()).path;
      }
    }
    else{
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
      dirLoc = "/sdcard/Adira PDF";
      print("cek dirLoc $dirLoc");
    }
  }
}