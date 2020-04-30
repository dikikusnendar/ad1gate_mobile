import 'dart:io';

import 'package:adira_finance/model/kecamatan_model.dart';
import 'package:adira_finance/model/pekerjaan_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  Database db;
  var _myPath;
  initDatabase() async{
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "kecamatan_android.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      }
      catch (_) {

      }

      // Copy from asset
      ByteData data = await rootBundle.load("assets/kecamatan.db");
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      _myPath = path;
      db = await openDatabase(_myPath);
//      List result = await db.rawQuery("select BranchName from t_save_draft");
//      if(result.isEmpty){
//
//      }
//      for(int i =0; i<result.length;i++){
//        print(result[i]);
//      }
    }
  }

  Future<KecamatanModel> getKecamatan() async{
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "kecamatan_android.db");
    db = await openDatabase(path);
    List result = await db.rawQuery("select * from m_kecamatan order by kecamatan asc");
    db.close();
    return KecamatanModel.fromJson(result);
  }

  Future<PekerJaanModel> getPekerjaan() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from m_pekerjaan");
    db.close();
    return PekerJaanModel.fromJson(result);
  }

  Future<PekerJaanModel> getPekerjaanByCode(String code) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from m_pekerjaan where occupation_code = '$code'");
    db.close();
    return PekerJaanModel.fromJson(result);
  }

  getKendaraan() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from m_kendaraan");
    print(result);
    db.close();
  }

  //Auto Assign
  addDateAutoAssign(List data) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    if(data.isNotEmpty){
      for(var i=0; i<data.length; i++){
        print("insert into t_date_by_auto_asign (tanggal,jam) values('${data[i]['tanggal']}','${data[i]['jam']}')");
        await db.rawQuery("insert into t_date_by_auto_asign (tanggal,jam) values('${data[i]['tanggal']}','${data[i]['jam']}')");
      }
    }
    db.close();
  }

  Future<List> getDateTimeAutoAssign() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from t_date_by_auto_asign");
    db.close();
    return result;
  }

  Future<List> getDateAutoAssign() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select tanggal from t_date_by_auto_asign");
    db.close();
    return result;
  }

  Future<List> getTimeByDateAutoAssign(String date) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    var data = await db.rawQuery("select jam from t_date_by_auto_asign where tanggal = '$date'");
    db.close();
    return data;
  }

  deleteDateAutoAssign()async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("delete from t_date_by_auto_asign");
    db.close();
  }
  //Auto Assign

  //DedicatedCMO
  Future<List> getDateTimeByDedicatedCMO() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from t_date_by_dedicate_cmo");
    db.close();
    return result;
  }

  addDateTimeByDedicatedCMO(List data) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    if(data.isNotEmpty){
      for(var i=0; i<data.length; i++){
        print("insert into t_date_by_dedicate_cmo (tanggal,jam) values('${data[i]['tanggal']}','${data[i]['jam']}')");
        await db.rawQuery("insert into t_date_by_dedicate_cmo (tanggal,jam) values('${data[i]['tanggal']}','${data[i]['jam']}')");
      }
    }
    db.close();
  }

  getDateByDedicatedCMO() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select tanggal from t_date_by_dedicate_cmo");
    db.close();
    return result;
  }

  deleteDateTimeByDedicatedCMO() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("delete from t_date_by_dedicate_cmo");
    db.close();
  }

  Future<List> getTimeByDateDedicatedCMO(String date) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    var data = await db.rawQuery("select jam from t_date_by_dedicate_cmo where tanggal = '$date'");
    db.close();
    return data;
  }
  //DedicatedCMO


  //AutoBranch
  deleteDataDateAndGenerate()async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("delete from t_date_and_branch");
    db.close();
  }

  Future<List> getDateByBranchId(String branchId) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    var data = await db.rawQuery("select date from t_date_and_branch where branch_id = '$branchId'");
    print(data);
    db.close();
    return data;
  }

  Future<List> getTimeByBranchAndDate(String branchId, String date) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    var data = await db.rawQuery("select time from t_date_and_branch where branch_id = '$branchId' and date = '$date'");
    db.close();
    return data;
  }

  addDateAndBranchdata(List data) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    if(data.isNotEmpty){
      for(var i=0; i<data.length; i++){
        print("insert into t_date_and_branch (branch_id,branch_name,date,time) values('${data[i]['branchId']}','${data[i]['branchName'].trim()}','${data[i]['date']}','${data[i]['time']}')");
        await db.rawQuery("insert into t_date_and_branch (branch_id,branch_name,date,time) values('${data[i]['branchId']}','${data[i]['branchName'].trim()}','${data[i]['date']}','${data[i]['time']}')");
      }
    }
    db.close();
  }

  Future<List> getDateAndBranchDate() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from t_date_and_branch");
    print(result);
    db.close();
    return result;
  }
  //AutoBranch

  //ByAsIs
  Future<List> getDateTimeByAsIs() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from t_date_time_by_asis");
    print(result);
    db.close();
    return result;
  }

  deleteDataDateByAsis()async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("delete from t_date_time_by_asis");
    db.close();
  }

  addDateByAsIs(List data) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    if(data.isNotEmpty){
      for(var i=0; i<data.length; i++){
        print("insert into t_date_time_by_asis (branch_id,branch_name,date,time) values('${data[i]['branchId']}','${data[i]['branchName'].trim()}','${data[i]['date']}','${data[i]['time']}')");
        await db.rawQuery("insert into t_date_time_by_asis (branch_id,branch_name,date,time) values('${data[i]['branchId']}','${data[i]['branchName'].trim()}','${data[i]['date']}','${data[i]['time']}')");
      }
    }
    db.close();
  }

  Future<List> getDateByAsIs(String branchId) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    var data = await db.rawQuery("select date from t_date_time_by_asis where branch_id = '$branchId'");
    print(data);
    db.close();
    return data;
  }

  Future<List> getTimeByDateAsIs(String branchId, String date) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    var data = await db.rawQuery("select time from t_date_time_by_asis where branch_id = '$branchId' and date = '$date'");
    db.close();
    return data;
  }

  insertIntoDraft(Map value) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    print(value);
    await db.rawQuery(
        "insert into t_save_draft (DlcCode,BranchID,KTP_No,LastName,BirthPlace,"
            "BirthDate,MarriageStatus,KTP_Address,KTP_RT,KTP_RW,KTP_Kelurahan,"
            "KTP_Kecamatan,KTP_KabKota,KTP_Provinsi,KTP_ZipCode,IsSameLifeAddress,"
            "Address,RT,RW,Kelurahan,Kecamatan,Kab_Kota,Provinsi,ZipCode,Survey_Address,"
            "Phone_No,Jenis_Kendaraan,Merk_Kendaraan,Type_kendaraan,Model_Kendaraan,Tahun_Kendaraan"
            ",OTR,Tenor,Gross_DP,NET_DP,Installment,SurveyDate,DLC_Note,Gender,HP_No,Jenis_Pembiayaan,"
            "BPKB_Name,Pekerjaan,CreateUserID,Longtitude,Latitude,JenisSurvey,Kelurahan_Id,Kecamatan_Id,"
            "Kab_Kota_Id,Provinsi_Id,KTP_Kelurahan_Id,KTP_Kecamatan_Id,KTP_Kab_Kota_Id,KTP_Provinsi_Id,Gender_Id,Pekerjaan_Id,Model_Kendaraan_Id,"
            "Type_kendaraan_iD,Merk_Kendaraan_iD,Jenis_Kendaraan_Id,Jenis_Pembiayaan_Id,JenisSurvey_Id,KodeVoucher,Location,Maiden_LastName,BranchName)"
        "values('${value['DlcCode']}','${value['BranchID']}','${value['KTP_No']}','${value['LastName']}',"
            "'${value['BirthPlace']}','${value['BirthDate']}','${value['MarriageStatus']}','${value['KTP_Address']}',"
            "'${value['KTP_RT']}','${value['KTP_RW']}','${value['KTP_Kelurahan']}','${value['KTP_Kecamatan']}',"
            "'${value['KTP_KabKota']}','${value['KTP_Provinsi']}','${value['KTP_ZipCode']}','${value['IsSameLifeAddress']}',"
            "'${value['Address']}','${value['RT']}','${value['RW']}','${value['Kelurahan']}',"
            "'${value['Kecamatan']}','${value['Kab_Kota']}','${value['Provinsi']}','${value['ZipCode']}',"
            "'${value['Survey_Address']}','${value['Phone_No']}','${value['Jenis_Kendaraan']}','${value['Merk_Kendaraan']}',"
            "'${value['Type_kendaraan']}','${value['Model_Kendaraan']}','${value['Tahun_Kendaraan']}','${value['OTR']}',"
            "'${value['Tenor']}','${value['Gross_DP']}','${value['NET_DP']}','${value['Installment']}',"
            "'${value['SurveyDate']}','${value['DLC_Note']}','${value['Gender']}','${value['HP_No']}','${value['Jenis_Pembiayaan']}',"
            "'${value['BPKB_Name']}','${value['Pekerjaan']}','${value['CreateUserID']}','${value['Longtitude']}','${value['Latitude']}',"
            "'${value['JenisSurvey']}','${value['Kelurahan_Id']}','${value['Kecamatan_Id']}','${value['Kab_Kota_Id']}',"
            "'${value['Provinsi_Id']}','${value['KTP_Kelurahan_Id']}','${value['KTP_Kecamatan_Id']}','${value['KTP_Kab_Kota_Id']}',"
            "'${value['KTP_Provinsi_Id']}','${value['Gender_Id']}','${value['Pekerjaan_Id']}','${value['Model_Kendaraan_Id']}',"
            "'${value['Type_kendaraan_iD']}','${value['Merk_Kendaraan_iD']}','${value['Jenis_Kendaraan_Id']}','${value['Jenis_Pembiayaan_Id']}',"
            "'${value['JenisSurvey_Id']}','${value['KodeVoucher']}','${value['Location']}','${value['Maiden_LastName']}','${value['BranchName']}')");
  }

  updateDraft(Map value, int id) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    print(value);
    await db.rawQuery(
        "UPDATE t_save_draft SET DlcCode = '${value['DlcCode']}',BranchID = '${value['BranchID']}', KTP_No = '${value['KTP_No']}',"
            "LastName = '${value['LastName']}',BirthPlace = '${value['BirthPlace']}',BirthDate = '${value['BirthDate']}',MarriageStatus = '${value['MarriageStatus']}',"
            "KTP_Address = '${value['KTP_Address']}',KTP_RT = '${value['KTP_RT']}',KTP_RW = '${value['KTP_RW']}',KTP_Kelurahan = '${value['KTP_Kelurahan']}',"
            "KTP_Kecamatan = '${value['KTP_Kecamatan']}',KTP_KabKota = '${value['KTP_KabKota']}',KTP_Provinsi = '${value['KTP_Provinsi']}',KTP_ZipCode = '${value['KTP_ZipCode']}',"
            "IsSameLifeAddress = '${value['IsSameLifeAddress']}',Address = '${value['Address']}',RT = '${value['RT']}',RW = '${value['RW']}',Kelurahan = '${value['Kelurahan']}',"
            "Kecamatan = '${value['Kecamatan']}',Kab_Kota = '${value['Kab_Kota']}',Provinsi = '${value['Provinsi']}',ZipCode = '${value['ZipCode']}',Survey_Address = '${value['Survey_Address']}',"
            "Phone_No = '${value['Phone_No']}',Jenis_Kendaraan = '${value['Jenis_Kendaraan']}',Merk_Kendaraan = '${value['Merk_Kendaraan']}',Type_kendaraan = '${value['Type_kendaraan']}',"
            "Model_Kendaraan = '${value['Model_Kendaraan']}',Tahun_Kendaraan = '${value['Tahun_Kendaraan']}',OTR = '${value['OTR']}',Tenor = '${value['Tenor']}',Gross_DP = '${value['Gross_DP']}',"
            "NET_DP = '${value['NET_DP']}',Installment = '${value['Installment']}',SurveyDate = '${value['SurveyDate']}',DLC_Note = '${value['DLC_Note']}',Gender = '${value['Gender']}',"
            "HP_No = '${value['HP_No']}',Jenis_Pembiayaan = '${value['Jenis_Pembiayaan']}',BPKB_Name = '${value['BPKB_Name']}',Pekerjaan = '${value['Pekerjaan']}',CreateUserID = '${value['CreateUserID']}',"
            "Longtitude = '${value['Longtitude']}',Latitude = '${value['Latitude']}',JenisSurvey = '${value['JenisSurvey']}',Kelurahan_Id = '${value['Kelurahan_Id']}',Kecamatan_Id = '${value['Kecamatan_Id']}',"
            "Kab_Kota_Id = '${value['Kab_Kota_Id']}',Provinsi_Id = '${value['Provinsi_Id']}',KTP_Kelurahan_Id = '${value['KTP_Kelurahan_Id']}',KTP_Kecamatan_Id = '${value['KTP_Kecamatan_Id']}',"
            "KTP_Kab_Kota_Id = '${value['KTP_Kab_Kota_Id']}',KTP_Provinsi_Id = '${value['KTP_Provinsi_Id']}',Gender_Id = '${value['Gender_Id']}',Pekerjaan_Id = '${value['Pekerjaan_Id']}',"
            "Model_Kendaraan_Id = '${value['Model_Kendaraan_Id']}',Type_kendaraan_iD = '${value['Type_kendaraan_iD']}',Merk_Kendaraan_iD = '${value['Merk_Kendaraan_iD']}',Jenis_Kendaraan_Id = '${value['Jenis_Kendaraan_Id']}',"
            "Jenis_Pembiayaan_Id = '${value['Jenis_Pembiayaan_Id']}',JenisSurvey_Id = '${value['JenisSurvey_Id']}',KodeVoucher = '${value['KodeVoucher']}',Location = '${value['Location']}',"
            "Maiden_LastName = '${value['Maiden_LastName']}',BranchName = '${value['BranchName']}' WHERE id = $id"
    );
  }

  Future<List> getDraft() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from t_save_draft");
    db.close();
    return result;
  }

  Future<List> getDraftID() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select id from t_save_draft");
    db.close();
    return result;
  }

  Future<List> getDraftWhereId(int id) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List result = await db.rawQuery("select * from t_save_draft where id = $id");
    print("cek hasil ${result[0]}");
    db.close();
    return result;
  }

  addDateLogin(String login, String logout) async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("INSERT INTO t_login (login_date,logout_date) VALUES('$login','$logout')");
    db.close();
  }

  Future<List> getDateLogin() async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    List _result = await db.rawQuery("SELECT * FROM t_login");
    db.close();
    return _result;
  }

  deleteDateLogin()async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("delete from t_login");
    db.close();
  }

  deleteRowDraft(int id)async{
    var _databasePath = await getDatabasesPath();
    var _path = join(_databasePath,"kecamatan_android.db");
    db = await openDatabase(_path);
    await db.rawQuery("delete from t_save_draft where id = $id");
    db.close();
  }
}