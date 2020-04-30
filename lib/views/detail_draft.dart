import 'package:adira_finance/db_helper/database_helper.dart';
import 'package:adira_finance/resources/submit_order_api_provider.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class DetailDraftPage extends StatefulWidget {
  final Map listDraftData;

  const DetailDraftPage({Key key, this.listDraftData}) : super(key: key);
  @override
  _DetailDraftPageState createState() => _DetailDraftPageState();
}

class _DetailDraftPageState extends State<DetailDraftPage> {
  var _getDataProcess = false;
  DbHelper _dbHelper = DbHelper();
  SubmitOrderForm _submitOrderForm = SubmitOrderForm();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draft Detail",style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)),
        centerTitle: true,
        backgroundColor: myPrimaryColor,
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                _prosesAndSend();
              },
              child: Text('Kirim',
                  style: TextStyle(fontFamily: "NunitoSans",color: Colors.black)
              )
          )
        ],
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: <Widget>[
            Text('Draft data',style: TextStyle(fontFamily: 'NunitoSansSemiBold',fontSize: 18)),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("DlcCode", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['DlcCode']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("BranchID", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['BranchID']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP_No", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_No']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Name", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['LastName']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Tempat lahir", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['BirthPlace']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Tanggal lahir", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['BirthDate']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Status pernikahan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['MarriageStatus']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Alamat KTP", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_Address']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP RT", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_RT']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP RW", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_RW']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP Kelurahan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_Kelurahan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP Kecamatan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_Kecamatan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP KabKota", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_KabKota']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP Provinsi", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_Provinsi']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("KTP ZipCode", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['KTP_ZipCode']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Survey Address", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Survey_Address']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("RT", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['RT']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("RW", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['RW']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Kelurahan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Kelurahan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Kecamatan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Kecamatan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Kab_Kota", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Kab_Kota']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Provinsi", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Provinsi']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("ZipCode", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['ZipCode']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Phone No", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Phone_No']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Jenis_Kendaraan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Jenis_Kendaraan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Merk Kendaraan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Merk_Kendaraan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Type_kendaraan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Model_Kendaraan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Tahun_Kendaraan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Tahun_Kendaraan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("OTR", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['OTR']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Tenor", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Tenor']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Gross_DP", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Gross_DP']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("NET_DP", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['NET_DP']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Angsuran", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Installment']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Tanggal Survey", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['SurveyDate']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Catatan Dealer", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['DLC_Note']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Gender", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Gender']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("HP No", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['HP_No']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Jenis_Pembiayaan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Jenis_Pembiayaan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("BPKB Name", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['BPKB_Name']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Pekerjaan", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Pekerjaan']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Email user", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['CreateUserID']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Longitude", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Longtitude']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("Latitude", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['Latitude']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
            SizedBox(height: 8),
            Row(
                children:  <Widget>[
                  Expanded(flex: 4, child: Text("JenisSurvey", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 0, child: Text(" : ", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                  Expanded(flex: 5, child: Text("${widget.listDraftData['JenisSurvey']}", style: TextStyle(fontFamily: "NunitoSans", fontSize: 16))),
                ]
            ),
          ],
        ),
      ),
    );
  }

  _prosesAndSend() async{
    setState(() {
      _getDataProcess = true;
    });
    int _id = widget.listDraftData['id'];
    var _body = {
      "DlcCode": widget.listDraftData['DlcCode'],
      "BranchID": widget.listDraftData['BranchID'],
      "KTP_No": widget.listDraftData['KTP_No'],
      "FirstName": "",
      "LastName": widget.listDraftData['LastName'],
      "MidName": "",
      "BirthPlace": widget.listDraftData['BirthPlace'],
      "BirthDate": widget.listDraftData['BirthDate'],
      "MarriageStatus": widget.listDraftData['MarriageStatus'],
      "KTP_Address": widget.listDraftData['KTP_Address'],
      "KTP_RT": widget.listDraftData['KTP_RT'],
      "KTP_RW": widget.listDraftData['KTP_RW'],
      "KTP_Kelurahan": widget.listDraftData['KTP_Kelurahan_Id'],
      "KTP_Kecamatan": widget.listDraftData['KTP_Kecamatan_Id'],
      "KTP_KabKota": widget.listDraftData['KTP_Kab_Kota_Id'],
      "KTP_Provinsi": widget.listDraftData['KTP_Provinsi_Id'],
      "KTP_ZipCode": widget.listDraftData['KTP_ZipCode'],
      "IsSameLifeAddress": widget.listDraftData['IsSameLifeAddress'],
      "Address": widget.listDraftData['Address'],
      "RT": widget.listDraftData['RT'],
      "RW": widget.listDraftData['RW'],
      "Kelurahan": widget.listDraftData['Kelurahan_Id'],
      "Kecamatan": widget.listDraftData['Kecamatan_Id'],
      "Kab_Kota": widget.listDraftData['Kab_Kota_Id'],
      "Provinsi": widget.listDraftData['Provinsi_Id'],
      "ZipCode": widget.listDraftData['ZipCode'],
      "Survey_Address": widget.listDraftData['Survey_Address'],
      "Phone_No": widget.listDraftData['Phone_No'],
      "Spouse_FirstName": "",
      "Spouse_LastName": "",
      "Maiden_FirstName": "",
      "Maiden_LastName": "",
      "Jenis_Kendaraan": widget.listDraftData['Jenis_Kendaraan_Id'],
      "Merk_Kendaraan": widget.listDraftData['Merk_Kendaraan_iD'],
      "Type_kendaraan": widget.listDraftData['Type_kendaraan_iD'],
      "Model_Kendaraan": widget.listDraftData['Model_Kendaraan_Id'],
      "Tahun_Kendaraan": widget.listDraftData['Tahun_Kendaraan'],
      "OTR": widget.listDraftData['OTR'],
      "Tenor": widget.listDraftData['Tenor'],
      "Gross_DP": widget.listDraftData['Gross_DP'],
      "NET_DP": widget.listDraftData['NET_DP'],
      "Installment": widget.listDraftData['Installment'],
      "SurveyDate": widget.listDraftData['SurveyDate'],
      "DLC_Note": widget.listDraftData['DLC_Note'],
      "Gender": widget.listDraftData['Gender_Id'],
      "HP_No": widget.listDraftData['HP_No'],
      "Jenis_Angsuran": "",
      "LeaseType": "",
      "Jenis_Pembiayaan": widget.listDraftData['Jenis_Pembiayaan_Id'],
      "BPKB_Name": widget.listDraftData['BPKB_Name'],
      "Eff_Rate": 0,
      "Flat_rate": 0,
      "Pekerjaan": widget.listDraftData['Pekerjaan_Id'],
      "Purpose": "",
      "CreateUserID": widget.listDraftData['CreateUserID'],
      "Longtitude": widget.listDraftData['Longtitude'],
      "Latitude": widget.listDraftData['Latitude'],
      "JenisSurvey":widget.listDraftData['JenisSurvey_Id'],
    };

    var _result = await _submitOrderForm.submitOrder(_body);
    if(_result['status']){
      _dbHelper.deleteRowDraft(_id);
      setState(() {
        _getDataProcess = false;
      });
      Navigator.pop(context,true);
    }
    else{
      setState(() {
        _getDataProcess = false;
      });
      return;
    }
  }
}
